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
    case viewModelRefresed(MasterSectionViewModel)
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
  private let bindFolderListUseCase: BindFolderListUseCase


  // MARK: initializing

  init(
    fetchFolderListUseCase: FetchFolderListUseCase,
    getFodlerListUseCase: GetFolderListUseCase,
    bindFolderListUseCase: BindFolderListUseCase
  ) {
    defer { _ = self.state }
    self.fetchFolderListUseCase = fetchFolderListUseCase
    self.getFolderListUseCase = getFodlerListUseCase
    self.bindFolderListUseCase = bindFolderListUseCase
    self.initialState = State()
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      bindFolderList()
      return .empty()
//      return fetchFolderListAndMakeViewModel()

    case .firstAPICallEnded:
      return .just(Mutation.setFirstAPICall)

    case .viewModelRefresed(let viewModel):
      return .just(Mutation.setViewModel(viewModel))
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

        var folderViewModels = folders.folders.map {
          let folderViewModel = MasterTabCellFolderView.ViewModel(
            id: $0.id,
            color: $0.backgroundColor,
            title: $0.title
          )

          return MasterTabCell.ViewModel(tabViewType: nil, folderViewModel: folderViewModel, isMakeButton: false)
        }

        folderViewModels.insert(
          .init(
            tabViewType: nil,
            folderViewModel: .init(
              id: Folder.all().id,
              color: Folder.all().backgroundColor,
              title: Folder.all().title
            ),
            isMakeButton: false
          ),
          at: 0
        )

        viewModel.items.insert(contentsOf: folderViewModels, at: 2)

        return .concat([
          .just(Mutation.setFolderList(folders.folders)),
          .just(Mutation.setViewModel(viewModel)),
        ])
      }
  }

  private func bindFolderList() {
    bindFolderListUseCase.execute()
      .subscribe(with: self) { `self`, folders in
        var viewModel = MasterSectionViewModel(section: .normal, items: [
          .init(tabViewType: .home, folderViewModel: nil, isMakeButton: false),
          .init(tabViewType: .folder, folderViewModel: nil, isMakeButton: false),
          .init(tabViewType: nil, folderViewModel: nil, isMakeButton: true),
          .init(tabViewType: .mypage, folderViewModel: nil, isMakeButton: false),
        ])

        var folderViewModels = folders.folders.map {
          let folderViewModel = MasterTabCellFolderView.ViewModel(
            id: $0.id,
            color: $0.backgroundColor,
            title: $0.title
          )

          return MasterTabCell.ViewModel(tabViewType: nil, folderViewModel: folderViewModel, isMakeButton: false)
        }

        folderViewModels.insert(
          .init(
            tabViewType: nil,
            folderViewModel: .init(
              id: Folder.all().id,
              color: Folder.all().backgroundColor,
              title: Folder.all().title
            ),
            isMakeButton: false
          ),
          at: 0
        )

        viewModel.items.insert(contentsOf: folderViewModels, at: 2)

        self.action.onNext(.viewModelRefresed(viewModel))
      }
      .disposed(by: disposeBag)
  }
}
