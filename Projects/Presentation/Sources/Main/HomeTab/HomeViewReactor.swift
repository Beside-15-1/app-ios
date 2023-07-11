//
//  HomeViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/05.
//

import Foundation

import ReactorKit
import RxSwift

import Domain
import PBLog

final class HomeViewReactor: Reactor {

  enum Action {
    case viewDidLoad
    case createFolderSucceed
  }

  enum Mutation {
    case setFolderList([Folder])
    case setViewModel(HomeFolderSectionViewModel)
  }

  struct State {

    var folderList: [Folder] = []
    var viewModel: HomeFolderSectionViewModel?
  }


  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let fetchFolderListUseCase: FetchFolderListUseCase


  // MARK: initializing

  init(
    fetchFolderListUseCase: FetchFolderListUseCase
  ) {
    defer { _ = self.state }

    self.fetchFolderListUseCase = fetchFolderListUseCase

    self.initialState = State()
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return fetchFolderList()

    case .createFolderSucceed:
      return fetchFolderList()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setFolderList(let folderList):
      newState.folderList = folderList

    case .setViewModel(let viewModel):
      newState.viewModel = viewModel
    }

    return newState
  }
}


extension HomeViewReactor {

  private func fetchFolderList() -> Observable<Mutation> {
    fetchFolderListUseCase.execute(sort: .createAt)
      .asObservable()
      .flatMap { folderList -> Observable<Mutation> in
        var viewModel = HomeFolderSectionViewModel(
          section: .normal,
          items: folderList.map {
            .init(
              id: $0.id,
              coverColor: $0.backgroundColor,
              titleColor: $0.titleColor,
              title: $0.title,
              linkCount: $0.linkCount,
              illust: $0.illustration,
              isLast: false
            )
          }
        )
        viewModel.items.append(.init(
          id: "default",
          coverColor: "",
          titleColor: "",
          title: "",
          linkCount: 0,
          illust: nil,
          isLast: true
        ))

        return .concat([
          .just(Mutation.setFolderList(folderList)),
          .just(Mutation.setViewModel(viewModel)),
        ])
      }
  }
}
