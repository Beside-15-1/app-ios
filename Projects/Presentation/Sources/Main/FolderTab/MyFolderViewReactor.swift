//
//  MyFolderViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/11.
//

import Foundation

import ReactorKit
import RxSwift

import Domain

final class MyFolderViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case viewDidLoad
  }

  enum Mutation {
    case setFolderList([Folder])
    case setFolderViewModel(MyFolderSectionViewModel)
  }

  struct State {
    var folderList: [Folder] = []
    var folderViewModel: MyFolderSectionViewModel?
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
    
    initialState = State()
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return fetchFolderList()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setFolderList(let list):
      newState.folderList = list

    case .setFolderViewModel(let viewModel):
      newState.folderViewModel = viewModel
    }

    return newState
  }
}


// MARK: - Private

extension MyFolderViewReactor {

  private func fetchFolderList() -> Observable<Mutation> {
    fetchFolderListUseCase.execute(sort: .createAt)
      .asObservable()
      .flatMap { folderList -> Observable<Mutation> in
        var viewModel = MyFolderSectionViewModel(
          section: .normal,
          items: folderList.map {
            .init(
              id: $0.id,
              coverColor: $0.backgroundColor,
              titleColor: $0.titleColor,
              title: $0.title,
              illust: $0.illustration,
              linkCount: $0.linkCount
            )
          }
        )

        return .concat([
          .just(Mutation.setFolderList(folderList)),
          .just(Mutation.setFolderViewModel(viewModel)),
        ])
      }
  }
}
