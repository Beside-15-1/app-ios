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
    case searchText(String)
    case createFolderSucceed
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

    case .searchText(let text):

      guard !text.isEmpty else {
        let viewModel = makeViewModel(withFolderList: currentState.folderList)

        return .just(Mutation.setFolderViewModel(viewModel))
      }

      let filteredList = currentState.folderList.filter {
        $0.title.range(of: text, options: .caseInsensitive) != nil
      }

      let viewModel = makeViewModel(withFolderList: filteredList)

      return .just(Mutation.setFolderViewModel(viewModel))

    case .createFolderSucceed:
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
      .flatMap { [weak self] folderList -> Observable<Mutation> in
        guard let self else { return .empty() }

        let viewModel = self.makeViewModel(withFolderList: folderList)

        return .concat([
          .just(Mutation.setFolderList(folderList)),
          .just(Mutation.setFolderViewModel(viewModel)),
        ])
      }
  }

  private func makeViewModel(withFolderList folderList: [Folder]) -> MyFolderSectionViewModel {
    MyFolderSectionViewModel(
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
  }
}
