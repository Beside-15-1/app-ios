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
import PBLog

final class FolderDetailViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case viewDidLoad
    case selectTab(String)
    case updateSort(LinkSortingType)
    case searchLink(String)
    case refresh
    case readLink(String)
    case updateUnreadFiltering(Bool)
    case createFolderSucceed
    case editingButtonTapped
    case endEditingMode
    case linkCheckBoxTapped(id: String)
    case deleteButtonTapped
    case selectAllCheckBoxTapped
  }

  enum Mutation {
    case setLinkList([Link])
    case setViewModel(FolderDetailSectionViewModel)
    case setSelectedFolder(Folder)
    case setSortingType(LinkSortingType)
    case setOrderType(SortingOrderType)
    case setRefreshEnd
    case setLinkCount(Int)
    case setEmptyLabelText(FolderDetailListView.EmptyViewModel)
    case setUnreadFiltering(Bool)
    case setEditing(Bool)
    case setSelectedLinkListOnEditingMode([Link])
  }

  struct State {
    let folderList: [Folder]
    var selectedFolder: Folder
    var linkCount = 0

    var linkList: [Link] = []

    var viewModel: FolderDetailSectionViewModel?

    var sortingType: LinkSortingType = .createAt
    var orderType: SortingOrderType = .desc
    var isUnreadFiltering = false

    var emptyLabelText: FolderDetailListView.EmptyViewModel = .init(text: "", bold: "")

    @Pulse var isEditing = false
    var selectedLinkListOnEditingMode: [Link] = []

    @Pulse var refreshEnd = false
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let linkRepository: LinkRepository
  private let fetchAllLinkUseCase: FetchAllLinksUseCase
  private let fetchLinkInFolderUseCase: FetchLinksInFolderUseCase
  private let getFolderListUseCase: GetFolderListUseCase
  private let readLinkUseCase: ReadLinkUseCase


  // MARK: initializing

  init(
    linkRepository: LinkRepository,
    fetchAllLinkUseCase: FetchAllLinksUseCase,
    fetchLinkInFolderUseCase: FetchLinksInFolderUseCase,
    getFolderListUseCase: GetFolderListUseCase,
    readLinkUseCase: ReadLinkUseCase,
    folderList: [Folder],
    selectedFolder: Folder
  ) {
    defer { _ = self.state }

    self.linkRepository = linkRepository
    self.fetchAllLinkUseCase = fetchAllLinkUseCase
    self.fetchLinkInFolderUseCase = fetchLinkInFolderUseCase
    self.getFolderListUseCase = getFolderListUseCase
    self.readLinkUseCase = readLinkUseCase

    var folders = getFolderListUseCase.execute().folders
    folders.insert(.all(count: getFolderListUseCase.execute().totalLinkCount), at: 0)

    self.initialState = State(
      folderList: folders,
      selectedFolder: selectedFolder,
      linkCount: selectedFolder.linkCount
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
        return fetchAllLinks(sort: currentState.sortingType, order: currentState.orderType)
      } else {
        return fetchLinksInFolder(
          id: currentState.selectedFolder.id,
          sort: currentState.sortingType,
          order: currentState.orderType
        )
      }

    case .selectTab(let tab):
      let selectedFolder = currentState.folderList.first(where: { $0.title == tab }) ?? .all()

      if selectedFolder.title == Folder.all().title {
        return .concat([
          .just(Mutation.setSelectedFolder(selectedFolder)),
          fetchAllLinks(sort: currentState.sortingType, order: currentState.orderType),
          .just(Mutation.setLinkCount(selectedFolder.linkCount)),
          .just(Mutation.setEditing(false)),
        ])
      } else {
        return .concat([
          .just(Mutation.setSelectedFolder(selectedFolder)),
          fetchLinksInFolder(id: selectedFolder.id, sort: currentState.sortingType, order: currentState.orderType),
          .just(Mutation.setLinkCount(selectedFolder.linkCount)),
          .just(Mutation.setEditing(false)),
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

        return .concat([
          .just(Mutation.setEmptyLabelText(.init(text: "아직 폴더에 저장된 링크가 없어요.", bold: ""))),
          .just(Mutation.setViewModel(viewModel)),
          .just(Mutation.setLinkCount(viewModel.items.count)),
        ])
      }

      let filteredList = currentState.linkList.filter {
        $0.title.range(of: text, options: .caseInsensitive) != nil
      }

      let viewModel = makeViewModel(
        withLinkList: filteredList,
        isAll: currentState.selectedFolder.title == Folder.all().title
      )

      return .concat([
        .just(Mutation.setEmptyLabelText(.init(text: "검색한 ‘\(text)' 링크가 없어요\n링크를 추가해보세요.", bold: text))),
        .just(Mutation.setViewModel(viewModel)),
        .just(Mutation.setLinkCount(filteredList.count)),
      ])

    case .refresh:
      let order: SortingOrderType = currentState.sortingType == .lastedAt ? .asc : .desc

      if currentState.selectedFolder.title == Folder.all().title {
        return fetchAllLinks(sort: currentState.sortingType, order: order)
      } else {
        return fetchLinksInFolder(
          id: currentState.selectedFolder.id,
          sort: currentState.sortingType,
          order: order
        )
      }

    case .readLink(let id):
      return readLinkUseCase.execute(id: id)
        .asObservable()
        .do(onNext: { [weak self] in
          self?.action.onNext(.refresh)
        })
        .flatMap { _ in Observable<Mutation>.empty() }

    case .updateUnreadFiltering(let isFiltering):
      return .concat([
        .just(Mutation.setUnreadFiltering(isFiltering)),
        updateUnreadFilter(isFiltering: isFiltering),
        .just(Mutation.setEditing(currentState.isEditing)),
        .just(Mutation.setSelectedLinkListOnEditingMode(currentState.selectedLinkListOnEditingMode)),
      ])

    case .createFolderSucceed:
      if currentState.selectedFolder.id == Folder.all().id {
        return fetchAllLinks(sort: currentState.sortingType, order: currentState.orderType)
      } else {
        return fetchLinksInFolder(
          id: currentState.selectedFolder.id,
          sort: currentState.sortingType,
          order: currentState.orderType
        )
      }

    case .editingButtonTapped:
      return .concat([
        .just(Mutation.setEditing(true)),
        .just(Mutation.setSelectedLinkListOnEditingMode([])),
//        .just(Mutation.setUnreadFiltering(false)),
//        updateUnreadFilter(isFiltering: false),
      ])

    case .endEditingMode:
      return .concat([
        .just(Mutation.setEditing(false)),
        .just(Mutation.setSelectedLinkListOnEditingMode([])),
      ])

    case .linkCheckBoxTapped(let id):

      var currentList = currentState.selectedLinkListOnEditingMode

      if let index = currentList.firstIndex(where: { $0.id == id }) {
        currentList.remove(at: index)
      } else {
        if let link = currentState.linkList.first(where: { $0.id == id }) {
          currentList.append(link)
        }
      }

      return .just(Mutation.setSelectedLinkListOnEditingMode(currentList))

    case .deleteButtonTapped:
      return .concat([
        deleteMultipleLink(),
        .just(Mutation.setSelectedLinkListOnEditingMode([])),
      ])

    case .selectAllCheckBoxTapped:
      guard let viewModel = currentState.viewModel else { return .empty() }

      if viewModel.items.count == currentState.selectedLinkListOnEditingMode.count {
        return .just(Mutation.setSelectedLinkListOnEditingMode([]))
      } else {
        let filteredList = currentState.linkList.filter { link in
          viewModel.items.contains(where: { $0.id == link.id })
        }
        return .just(Mutation.setSelectedLinkListOnEditingMode(filteredList))
      }
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

    case .setOrderType(let type):
      newState.orderType = type

    case .setRefreshEnd:
      newState.refreshEnd = true

    case .setLinkCount(let count):
      newState.linkCount = count

    case .setEmptyLabelText(let text):
      newState.emptyLabelText = text

    case .setUnreadFiltering(let filtering):
      newState.isUnreadFiltering = filtering

    case .setEditing(let isEditing):
      newState.isEditing = isEditing

    case .setSelectedLinkListOnEditingMode(let linkList):
      newState.selectedLinkListOnEditingMode = linkList
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
          .just(Mutation.setRefreshEnd),
          .just(Mutation.setLinkList(links)),
          .just(Mutation.setViewModel(viewModel)),
          .just(Mutation.setLinkCount(links.count)),
        ])
      }
      .catch { _ in
        .just(Mutation.setRefreshEnd)
      }
  }

  private func fetchLinksInFolder(id: String, sort: LinkSortingType, order: SortingOrderType) -> Observable<Mutation> {
    fetchLinkInFolderUseCase.execute(linkBookId: id, sort: sort, order: order)
      .asObservable()
      .flatMap { links -> Observable<Mutation> in
        let viewModel = self.makeViewModel(withLinkList: links, isAll: false)

        return .concat([
          .just(Mutation.setRefreshEnd),
          .just(Mutation.setLinkList(links)),
          .just(Mutation.setViewModel(viewModel)),
          .just(Mutation.setLinkCount(links.count)),
        ])
      }.catch { _ in
        .just(Mutation.setRefreshEnd)
      }
  }

  private func updateSort(type: LinkSortingType) -> Observable<Mutation> {
    let order: SortingOrderType

    switch type {
    case .createAt:
      order = .desc
    case .lastedAt:
      order = .asc
    case .title:
      order = .asc
    case .updatedAt:
      order = .asc
    }

    if currentState.selectedFolder.title == Folder.all().title {
      return .concat([
        .just(Mutation.setSortingType(type)),
        .just(Mutation.setOrderType(order)),
        fetchAllLinks(sort: type, order: order),
      ])
    } else {
      return .concat([
        .just(Mutation.setSortingType(type)),
        .just(Mutation.setOrderType(order)),
        fetchLinksInFolder(id: currentState.selectedFolder.id, sort: type, order: order),
      ])
    }
  }

  private func updateUnreadFilter(isFiltering: Bool) -> Observable<Mutation> {
    var unreadFilteredLinkList = currentState.linkList

    if isFiltering {
      unreadFilteredLinkList = currentState.linkList.filter { $0.readCount == 0 }
    }

    let viewModel = FolderDetailSectionViewModel(
      section: .normal,
      items: unreadFilteredLinkList.map {
        .init(
          id: $0.id,
          title: $0.title,
          tags: $0.tags,
          thumbnailURL: $0.thumbnailURL,
          url: $0.url,
          createAt: $0.createdAt,
          folderName: $0.folderName,
          isAll: true,
          readCount: $0.readCount
        )
      }
    )

    return .just(Mutation.setViewModel(viewModel))
  }

  private func makeViewModel(withLinkList linkList: [Link], isAll: Bool) -> FolderDetailSectionViewModel {
    var unreadFilteredLinkList: [Link]

    if currentState.isUnreadFiltering {
      unreadFilteredLinkList = linkList.filter { $0.readCount == 0 }
    } else {
      unreadFilteredLinkList = linkList
    }

    return FolderDetailSectionViewModel(
      section: .normal,
      items: unreadFilteredLinkList.map {
        .init(
          id: $0.id,
          title: $0.title,
          tags: $0.tags,
          thumbnailURL: $0.thumbnailURL,
          url: $0.url,
          createAt: $0.createdAt,
          folderName: $0.folderName,
          isAll: isAll,
          readCount: $0.readCount
        )
      }
    )
  }

  private func deleteMultipleLink() -> Observable<Mutation> {
    linkRepository.deleteMultipleLink(idList: currentState.selectedLinkListOnEditingMode.map { $0.id })
      .asObservable()
      .do(onNext: { [weak self] in
        self?.action.onNext(.refresh)
      })
      .flatMap { _ in Observable<Mutation>.empty() }
  }
}
