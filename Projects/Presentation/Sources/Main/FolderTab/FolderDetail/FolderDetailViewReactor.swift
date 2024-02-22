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
import PBAnalyticsInterface
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
    case createFolderSucceed
    case editingButtonTapped
    case endEditingMode
    case linkCheckBoxTapped(id: String)
    case deleteButtonTapped
    case selectAllCheckBoxTapped
    case updateCustomFilter(CustomFilter?)
  }

  enum Mutation {
    case setLinkList([Link])
    case setViewModel(FolderDetailSectionViewModel)
    case setSelectedFolder(Folder)
    case setSortingType(LinkSortingType)
    case setOrderType(SortingOrderType)
    case setRefreshEnd
    case setEmptyLabelText(FolderDetailListView.EmptyViewModel)
    case setUnreadFiltering(Bool)
    case setEditing(Bool)
    case setSelectedLinkListOnEditingMode([Link])
    case setSearchText(String)
    case setCustomFilter(CustomFilter?)
    case updateViewModels
  }

  struct State {
    let folderList: [Folder]
    var selectedFolder: Folder
    var linkList: [Link] = []
    var linkCount = 0

    var viewModel: FolderDetailSectionViewModel?

    // States related to displaying the link list
    var sortingType: LinkSortingType = .createAt
    var orderType: SortingOrderType = .desc
    var isUnreadFiltering = false
    @Pulse var isEditing = false
    var searchText = ""

    var emptyLabelText: FolderDetailListView.EmptyViewModel = .init(text: "", bold: "")

    var selectedLinkListOnEditingMode: [Link] = []

    var customFilter: CustomFilter?

    @Pulse var refreshEnd = false
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let analytics: PBAnalytics

  private let linkRepository: LinkRepository
  private let fetchAllLinkUseCase: FetchAllLinksUseCase
  private let fetchLinkInFolderUseCase: FetchLinksInFolderUseCase
  private let getFolderListUseCase: GetFolderListUseCase
  private let readLinkUseCase: ReadLinkUseCase


  // MARK: initializing

  init(
    analytics: PBAnalytics,
    linkRepository: LinkRepository,
    fetchAllLinkUseCase: FetchAllLinksUseCase,
    fetchLinkInFolderUseCase: FetchLinksInFolderUseCase,
    getFolderListUseCase: GetFolderListUseCase,
    readLinkUseCase: ReadLinkUseCase,
    folderList: [Folder],
    selectedFolder: Folder
  ) {
    defer { _ = self.state }

    self.analytics = analytics
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
        return .concat([
          fetchAllLinks(sort: currentState.sortingType, order: currentState.orderType),
          .just(Mutation.updateViewModels),
        ])
      } else {
        return .concat([
          fetchLinksInFolder(
            id: currentState.selectedFolder.id,
            sort: currentState.sortingType,
            order: currentState.orderType
          ),
          .just(Mutation.updateViewModels),
        ])
      }

    case .selectTab(let tab):
      let selectedFolder = currentState.folderList.first(where: { $0.title == tab }) ?? .all()

      if selectedFolder.title == Folder.all().title {
        return .concat([
          .just(Mutation.setSelectedFolder(selectedFolder)),
          fetchAllLinks(sort: currentState.sortingType, order: currentState.orderType),
          .just(Mutation.setEditing(false)),
          .just(Mutation.updateViewModels),
        ])
      } else {
        return .concat([
          .just(Mutation.setSelectedFolder(selectedFolder)),
          fetchLinksInFolder(
            id: selectedFolder.id,
            sort: currentState.sortingType,
            order: currentState.orderType
          ),
          .just(Mutation.setEditing(false)),
          .just(Mutation.updateViewModels),
        ])
      }

    case .updateSort(let type):
      return updateSort(type: type)

    case .searchLink(let text):

      let emptyLabelTitle = text.isEmpty ? "아직 폴더에 저장된 링크가 없어요." : "검색한 ‘\(text)' 링크가 없어요\n링크를 추가해보세요."

      return .concat([
        .just(Mutation.setSearchText(text)),
        .just(Mutation.setEmptyLabelText(.init(text: emptyLabelTitle, bold: text))),
        .just(Mutation.updateViewModels),
      ])

    case .refresh:
      let order: SortingOrderType = currentState.sortingType == .lastedAt ? .asc : .desc

      if currentState.selectedFolder.title == Folder.all().title {
        return .concat([
          fetchAllLinks(sort: currentState.sortingType, order: order),
          .just(Mutation.updateViewModels),
        ])
      } else {
        return .concat([
          fetchLinksInFolder(
            id: currentState.selectedFolder.id,
            sort: currentState.sortingType,
            order: order
          ),
          .just(Mutation.updateViewModels),
        ])
      }

    case .readLink(let id):
      return readLinkUseCase.execute(id: id)
        .asObservable()
        .do(onNext: { [weak self] in
          self?.action.onNext(.refresh)
        })
        .flatMap { _ in Observable<Mutation>.empty() }

    case .createFolderSucceed:
      if currentState.selectedFolder.id == Folder.all().id {
        return fetchAllLinks(sort: currentState.sortingType, order: currentState.orderType)
      } else {
        return .concat([
          fetchLinksInFolder(
            id: currentState.selectedFolder.id,
            sort: currentState.sortingType,
            order: currentState.orderType
          ),
          .just(Mutation.updateViewModels),
        ])
      }

    case .editingButtonTapped:
      analytics.log(type: LinkListEvent.click(component: .editOn))

      return .concat([
        .just(Mutation.setEditing(true)),
        .just(Mutation.setSelectedLinkListOnEditingMode([])),
        .just(Mutation.updateViewModels),
      ])

    case .endEditingMode:
      analytics.log(type: LinkListEvent.click(component: .editOff))

      return .concat([
        .just(Mutation.setEditing(false)),
        .just(Mutation.setSelectedLinkListOnEditingMode([])),
        .just(Mutation.updateViewModels),
      ])

    case .linkCheckBoxTapped(let id):

      analytics.log(type: LinkListEvent.click(component: .checkLink))

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
      analytics.log(type: LinkListEvent.click(component: .deleteLink))

      return .concat([
        deleteMultipleLink(),
        .just(Mutation.setSelectedLinkListOnEditingMode([])),
      ])

    case .selectAllCheckBoxTapped:
      guard let viewModel = currentState.viewModel else { return .empty() }

      analytics.log(type: LinkListEvent.click(component: .checkAll))

      if viewModel.items.count == currentState.selectedLinkListOnEditingMode.count {
        return .just(Mutation.setSelectedLinkListOnEditingMode([]))
      } else {
        let filteredList = currentState.linkList.filter { link in
          viewModel.items.contains(where: { $0.id == link.id })
        }
        return .just(Mutation.setSelectedLinkListOnEditingMode(filteredList))
      }

    case .updateCustomFilter(let customFilter):
      return .concat([
        .just(Mutation.setCustomFilter(customFilter)),
        .just(Mutation.updateViewModels),
      ])
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

    case .setEmptyLabelText(let text):
      newState.emptyLabelText = text

    case .setUnreadFiltering(let filtering):
      newState.isUnreadFiltering = filtering

    case .setEditing(let isEditing):
      newState.isEditing = isEditing

    case .setSelectedLinkListOnEditingMode(let linkList):
      newState.selectedLinkListOnEditingMode = linkList

    case .setSearchText(let text):
      newState.searchText = text

    case .setCustomFilter(let filter):
      newState.customFilter = filter

    case .updateViewModels:
      let isUnreadFiltering = newState.isUnreadFiltering
      let isEditing = newState.isEditing
      let searchText = newState.searchText
      let isAll = newState.selectedFolder.id == Folder.all().id

      var filteredLinkList = newState.linkList

      // 검색 텍스트
      if !searchText.isEmpty {
        filteredLinkList = filteredLinkList.filter {
          $0.title.range(of: searchText, options: .caseInsensitive) != nil
        }
      }

      // 커스텀 필터
      if let customFilter = currentState.customFilter {
        // 읽지 않음
        if customFilter.isUnreadFiltering {
          filteredLinkList = filteredLinkList.filter { $0.readCount == 0 }
        }

        if !customFilter.selectedTagList.isEmpty {
          filteredLinkList = filteredLinkList.filter { link in
            link.tags.contains(where: { tag in customFilter.selectedTagList.contains { tag == $0 } })
          }
        }

        filteredLinkList = filteredLinkList.filter { link in
          isDateInRange(
            createdAt: link.createdAt,
            periodType: customFilter.periodType,
            customPeriod: customFilter.customPeriod
          )
        }
      }

      newState.viewModel = FolderDetailSectionViewModel(
        section: .normal,
        items: filteredLinkList.map {
          .init(
            id: $0.id,
            title: $0.title,
            tags: $0.tags,
            thumbnailURL: $0.thumbnailURL,
            url: $0.url,
            createAt: $0.createdAt,
            folderName: $0.folderName,
            isAll: isAll,
            readCount: $0.readCount,
            isEditing: isEditing
          )
        }
      )

      newState.linkCount = newState.viewModel?.items.count ?? 0
    }

    return newState
  }
}

func isDateInRange(createdAt: String, periodType: PeriodType, customPeriod: CustomPeriod) -> Bool {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
  guard let createdDate = dateFormatter.date(from: createdAt) else {
    return true
  }

  switch periodType {
  case .all:
    return true

  case .week:
    let startDate = Date(timeIntervalSinceNow: -3600 * 24 * 7)
    let endDate = Date()
    return createdDate >= startDate && createdDate <= endDate


  case .month:
    let startDate = Date(timeIntervalSinceNow: -3600 * 24 * 30)
    let endDate = Date()
    return createdDate >= startDate && createdDate <= endDate

  case .custom:
    return createdDate >= customPeriod.startDate && createdDate <= customPeriod.endDate
  }
}


// MARK: - Private

extension FolderDetailViewReactor {

  private func fetchAllLinks(sort: LinkSortingType, order: SortingOrderType) -> Observable<Mutation> {
    fetchAllLinkUseCase.execute(sort: sort, order: order)
      .asObservable()
      .flatMap { links -> Observable<Mutation> in
        .concat([
          .just(Mutation.setRefreshEnd),
          .just(Mutation.setLinkList(links)),
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
        .concat([
          .just(Mutation.setRefreshEnd),
          .just(Mutation.setLinkList(links)),
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

  private func deleteMultipleLink() -> Observable<Mutation> {
    guard var deleteList = currentState.viewModel?.items else { return .empty() }

    deleteList = deleteList.filter { item in
      currentState.selectedLinkListOnEditingMode.contains(where: { $0.id == item.id })
    }

    return linkRepository.deleteMultipleLink(idList: deleteList.map { $0.id })
      .asObservable()
      .do(onNext: { [weak self] in
        self?.action.onNext(.refresh)
      })
      .flatMap { _ in Observable<Mutation>.empty() }
  }
}
