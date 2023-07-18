//
//  FolderDetailViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/17.
//

import Foundation

import ReactorKit
import RxSwift

import Domain

final class FolderDetailViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case viewDidLoad
    case selectTab(String)
    case updateSort(LinkSortingType)
    case searchLink(String)
  }

  enum Mutation {
    case setLinkList([Link])
    case setViewModel(FolderDetailSectionViewModel)
    case setSelectedFolder(Folder)
    case setSortingType(LinkSortingType)
  }

  struct State {
    let folderList: [Folder]
    var selectedFolder: Folder

    var linkList: [Link] = []

    var viewModel: FolderDetailSectionViewModel?

    var sortingType: LinkSortingType = .createAt
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let fetchAllLinkUseCase: FetchAllLinksUseCase
  private let fetchLinkInFolderUseCase: FetchLinksInFolderUseCase


  // MARK: initializing

  init(
    fetchAllLinkUseCase: FetchAllLinksUseCase,
    fetchLinkInFolderUseCase: FetchLinksInFolderUseCase,
    folderList: [Folder],
    selectedFolder: Folder
  ) {
    defer { _ = self.state }

    self.fetchAllLinkUseCase = fetchAllLinkUseCase
    self.fetchLinkInFolderUseCase = fetchLinkInFolderUseCase

    var folders = folderList
    folders.insert(
      Folder.all(),
      at: 0
    )

    self.initialState = State(
      folderList: folders,
      selectedFolder: selectedFolder
    )
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      if currentState.selectedFolder.id == Folder.all().id {
        return fetchAllLinks(sort: currentState.sortingType, order: .asc)
      } else {
        return fetchLinksInFolder(id: currentState.selectedFolder.id, sort: currentState.sortingType, order: .asc)
      }

    case .selectTab(let tab):
      let selectedFolder = currentState.folderList.first(where: { $0.title == tab }) ?? .all()

      let order: SortingOrderType = currentState.sortingType == .lastedAt ? .desc : .asc

      if selectedFolder.title == Folder.all().title {
        return .concat([
          .just(Mutation.setSelectedFolder(selectedFolder)),
          fetchAllLinks(sort: currentState.sortingType, order: order),
        ])
      } else {
        return .concat([
          .just(Mutation.setSelectedFolder(selectedFolder)),
          fetchLinksInFolder(id: selectedFolder.id, sort: currentState.sortingType, order: order),
        ])
      }

    case .updateSort(let type):
      return updateSort(type: type)

    case .searchLink(let text):

      guard !text.isEmpty else {
        let viewModel = makeViewModel(
          withLinkList: currentState.linkList,
          isAll: currentState.selectedFolder.title == Folder.all().title
        )

        return .just(Mutation.setViewModel(viewModel))
      }

      let filteredList = currentState.linkList.filter {
        $0.title.range(of: text, options: .caseInsensitive) != nil
      }

      let viewModel = makeViewModel(
        withLinkList: filteredList,
        isAll: currentState.selectedFolder.title == Folder.all().title
      )

      return .just(Mutation.setViewModel(viewModel))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setLinkList(let links):
      newState.linkList = links

    case .setViewModel(let viewModel):
      newState.viewModel = viewModel

    case .setSelectedFolder(let folder):
      newState.selectedFolder = folder

    case .setSortingType(let type):
      newState.sortingType = type
    }

    return newState
  }
}


// MARK: - Private

extension FolderDetailViewReactor {

  private func fetchAllLinks(sort: LinkSortingType, order: SortingOrderType) -> Observable<Mutation> {
    fetchAllLinkUseCase.execute(sort: sort, order: order)
      .asObservable()
      .flatMap { links -> Observable<Mutation> in
        let viewModel = self.makeViewModel(withLinkList: links, isAll: true)
        return .concat([
          .just(Mutation.setLinkList(links)),
          .just(Mutation.setViewModel(viewModel)),
        ])
      }
  }

  private func fetchLinksInFolder(id: String, sort: LinkSortingType, order: SortingOrderType) -> Observable<Mutation> {
    fetchLinkInFolderUseCase.execute(linkBookId: id, sort: sort, order: order)
      .asObservable()
      .flatMap { links -> Observable<Mutation> in
        let viewModel = self.makeViewModel(withLinkList: links, isAll: false)

        return .concat([
          .just(Mutation.setLinkList(links)),
          .just(Mutation.setViewModel(viewModel)),
        ])
      }
  }

  private func updateSort(type: LinkSortingType) -> Observable<Mutation> {
    let order: SortingOrderType = type == .lastedAt ? .desc : .asc

    if currentState.selectedFolder.title == Folder.all().title {
      return .concat([
        .just(Mutation.setSortingType(type)),
        fetchAllLinks(sort: type, order: order),
      ])
    } else {
      return .concat([
        .just(Mutation.setSortingType(type)),
        fetchLinksInFolder(id: currentState.selectedFolder.id, sort: type, order: order)
      ])
    }
  }

  private func makeViewModel(withLinkList linkList: [Link], isAll: Bool) -> FolderDetailSectionViewModel {
    FolderDetailSectionViewModel(
      section: .normal,
      items: linkList.map {
        .init(
          id: $0.id,
          title: $0.title,
          tags: $0.tags,
          thumbnailURL: $0.thumbnailURL,
          url: $0.url,
          createAt: $0.createdAt,
          folderName: $0.folderName,
          isAll: isAll
        )
      }
    )
  }


}
