//
//  MoveFolderViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/19.
//

import Foundation

import ReactorKit
import RxSwift

import Domain

final class MoveFolderViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case viewDidLoad
    case itemTapped(row: Int)
  }

  enum Mutation {
    case setViewModel(MoveFolderSectionViewModel)
    case setFolderList([Folder])
    case setSelectedIndex(Int)
  }

  struct State {
    var viewModel: MoveFolderSectionViewModel?
    var folderList: [Folder] = []

    var selectedIndex = 0

    let folderId: String
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let fetchFolderListUseCase: FetchFolderListUseCase


  // MARK: initializing

  init(
    fetchFolderListUseCase: FetchFolderListUseCase,
    folderId: String
  ) {
    defer { _ = self.state }

    self.fetchFolderListUseCase = fetchFolderListUseCase

    self.initialState = State(
      folderId: folderId
    )
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return fetchFolderList()

    case .itemTapped(let row):
      return .just(Mutation.setSelectedIndex(row))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setViewModel(let viewModel):
      newState.viewModel = viewModel

    case .setFolderList(let list):
      newState.folderList = list

    case .setSelectedIndex(let row):
      newState.selectedIndex = row
    }

    return newState
  }
}


// MARK: - Private

extension MoveFolderViewReactor {

  private func fetchFolderList() -> Observable<Mutation> {
    fetchFolderListUseCase.execute(sort: .createAt)
      .asObservable()
      .flatMap { [weak self] folderList -> Observable<Mutation> in
        guard let self else { return .empty() }

        let viewModel = MoveFolderSectionViewModel(
          section: .normal,
          items: folderList.map {
            MoveFolderCell.ViewModel(
              id: $0.id,
              coverColor: $0.backgroundColor,
              titleColor: $0.titleColor,
              title: $0.title,
              illust: $0.illustration,
              isCurrentFolder: $0.id == self.currentState.folderId
            )
          }
        )

        let index = folderList.firstIndex(where: { $0.id == self.currentState.folderId }) ?? 0

        return .concat([
          .just(Mutation.setFolderList(folderList)),
          .just(Mutation.setViewModel(viewModel)),
          .just(Mutation.setSelectedIndex(index))
        ])
      }
  }
}
