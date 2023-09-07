//
//  MasterViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/28.
//

import Foundation

import ReactorKit
import RxSwift

import Domain

final class MasterViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case viewDidLoad
    case firstAPICallEnded
  }

  enum Mutation {
    case setFolderList([Folder])
    case setViewModel(MasterSectionViewModel)
    case setFirstAPICall
  }

  struct State {
    var folderList: [Folder] = []
    var viewModel: MasterSectionViewModel?
    var isFirstAPICall = true
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let fetchFolderListUseCase: FetchFolderListUseCase
  private let getFolderListUseCase: GetFolderListUseCase


  // MARK: initializing

  init(
    fetchFolderListUseCase: FetchFolderListUseCase,
    getFodlerListUseCase: GetFolderListUseCase
  ) {
    defer { _ = self.state }
    self.fetchFolderListUseCase = fetchFolderListUseCase
    self.getFolderListUseCase = getFodlerListUseCase
    self.initialState = State()
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return fetchFolderListAndMakeViewModel()

    case .firstAPICallEnded:
      return .just(Mutation.setFirstAPICall)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setFolderList(let folderList):
      newState.folderList = folderList

    case .setViewModel(let viewModel):
      newState.viewModel = viewModel

    case .setFirstAPICall:
      newState.isFirstAPICall = false
    }

    return newState
  }
}


// MARK: - Private

extension MasterViewReactor {

  private func fetchFolderListAndMakeViewModel() -> Observable<Mutation> {
    fetchFolderListUseCase.execute(sort: .createAt)
      .asObservable()
      .catchAndReturn(.init(folders: [], totalLinkCount: 0))
      .flatMap { folders -> Observable<Mutation> in

        var viewModel = MasterSectionViewModel(section: .normal, items: [
          .init(tabViewType: .home, folderViewModel: nil, isMakeButton: false),
          .init(tabViewType: .folder, folderViewModel: nil, isMakeButton: false),
          .init(tabViewType: nil, folderViewModel: nil, isMakeButton: true),
          .init(tabViewType: .mypage, folderViewModel: nil, isMakeButton: false),
        ])

        let folderViewModels = folders.folders.map {
          let folderViewModel = MasterTabCellFolderView.ViewModel(
            id: $0.id,
            color: $0.backgroundColor,
            title: $0.title
          )

          return MasterTabCell.ViewModel(tabViewType: nil, folderViewModel: folderViewModel, isMakeButton: false)
        }

        viewModel.items.insert(contentsOf: folderViewModels, at: 2)

        return .concat([
          .just(Mutation.setFolderList(folders.folders)),
          .just(Mutation.setViewModel(viewModel)),
        ])
      }
  }
}
