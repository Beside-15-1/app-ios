//
//  HomeFeedViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 6/21/24.
//

import Foundation

import ReactorKit
import RxSwift

import Domain

final class HomeFeedViewReactor: Reactor {

  typealias HomeFeedSectionViewModel = SectionViewModel<HomeFeedModel.Section, HomeFeedModel.Item>

  // MARK: Action & Mutation & State

  enum Action {
    case viewDidLoad
    case recentlySavedButtonTapped
    case noReadButtonTapped
    case readLink(String)
    case refresh
  }

  enum Mutation {
    case updateSectionViewModels
    case setBannerSectionViewModel(HomeFeedSectionViewModel)
    case setLinkSectionViewModel(HomeFeedSectionViewModel?)
    case setMoreSectionViewModel(HomeFeedSectionViewModel?)
    case setTab(HomeFeedTab)
  }

  struct State {
    var sectionViewModels: [HomeFeedSectionViewModel] = []

    var bannerSectionViewModel: HomeFeedSectionViewModel?
    var linkSectionViewModel: HomeFeedSectionViewModel?
    var moreSectionViewModel: HomeFeedSectionViewModel?

    var tab: HomeFeedTab = .recentlySaved
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let fetchLinkListUseCase: FetchAllLinksUseCase
  private let readLinkUseCase: ReadLinkUseCase
  private let fetchFolderListUseCase: FetchFolderListUseCase


  // MARK: initializing

  init(
    fetchLinkListUseCase: FetchAllLinksUseCase,
    readLinkUseCase: ReadLinkUseCase,
    fetchFolderListUseCase: FetchFolderListUseCase
  ) {
    defer { _ = self.state }
    self.fetchLinkListUseCase = fetchLinkListUseCase
    self.readLinkUseCase = readLinkUseCase
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
      return .concat([
        syncFolderList(),
        fetchLinks(tab: currentState.tab),
        .just(Mutation.updateSectionViewModels),
      ])

    case .recentlySavedButtonTapped:
      return .concat([
        .just(Mutation.setTab(.recentlySaved)),
        fetchLinks(tab: .recentlySaved),
        .just(Mutation.updateSectionViewModels),
      ])

    case .noReadButtonTapped:
      return .concat([
        .just(Mutation.setTab(.noRead)),
        fetchLinks(tab: .noRead),
        .just(Mutation.updateSectionViewModels),
      ])

    case .readLink(let id):
      return readLinkUseCase.execute(id: id)
        .asObservable()
        .do(onNext: { [weak self] in
          self?.action.onNext(.refresh)
        })
        .flatMap { _ in Observable<Mutation>.empty() }

    case .refresh:
      switch currentState.tab {
      case .recentlySaved:
        return .concat([
          .just(Mutation.setTab(.recentlySaved)),
          fetchLinks(tab: .recentlySaved),
          .just(Mutation.updateSectionViewModels),
        ])

      case .noRead:
        return .concat([
          .just(Mutation.setTab(.noRead)),
          fetchLinks(tab: .noRead),
          .just(Mutation.updateSectionViewModels),
        ])
      }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .updateSectionViewModels:
      var sectionViewModels: [SectionViewModel<HomeFeedModel.Section, HomeFeedModel.Item>] = []

      if let bannerSectionViewModel = newState.bannerSectionViewModel {
        sectionViewModels.append(bannerSectionViewModel)
      }

      if let linkSectionViewModel = newState.linkSectionViewModel {
        sectionViewModels.append(linkSectionViewModel)
      }

      if let moreSectionViewModel = newState.moreSectionViewModel {
        sectionViewModels.append(moreSectionViewModel)
      }

      newState.sectionViewModels = sectionViewModels

    case .setBannerSectionViewModel(let viewModel):
      newState.bannerSectionViewModel = viewModel

    case .setLinkSectionViewModel(let viewModel):
      newState.linkSectionViewModel = viewModel

    case .setMoreSectionViewModel(let viewModel):
      newState.moreSectionViewModel = viewModel

    case .setTab(let homeFeedTab):
      newState.tab = homeFeedTab
    }

    return newState
  }
}


// MARK: - Private

extension HomeFeedViewReactor {

  private func fetchLinks(tab: HomeFeedTab) -> Observable<Mutation> {
    switch tab {
    case .recentlySaved:
      return fetchRecentlySavedLinks()

    case .noRead:
      return fetchNoReadLinks()
    }
  }

  private func fetchRecentlySavedLinks() -> Observable<Mutation> {
    fetchLinkListUseCase.execute(sort: .createAt, order: .desc)
      .asObservable()
      .flatMap { list -> Observable<Mutation> in
        let lastIndex = list.count < 5 ? list.endIndex : list.index(0, offsetBy: 5)
        let linkList = list[list.startIndex..<lastIndex]

        // 링크 자체가 존재 X
        if list.count == 0 {
          return .concat([
            .just(Mutation.setBannerSectionViewModel(.init(
              section: .init(id: .banner, title: "banner"),
              items: [.banner(.init(id: "banner", imageURL: nil, type: .recentlySaved))]
            ))),
            .just(Mutation.setLinkSectionViewModel(nil)),
            .just(Mutation.setMoreSectionViewModel(nil)),
          ])
        }

        return .concat([
          .just(Mutation.setBannerSectionViewModel(.init(
            section: .init(id: .banner, title: "banner"),
            items: [.banner(.init(id: "banner", imageURL: nil, type: .recentlySaved))]
          ))),
          .just(Mutation.setLinkSectionViewModel(.init(
            section: .init(id: .normal, title: "normal"),
            items: linkList.map { link in
              HomeFeedModel.Item.link(.init(
                id: link.id,
                imageURL: link.thumbnailURL,
                linkURL: link.url,
                title: link.title,
                tagList: link.tags,
                date: link.createdAt
              ))
            }
          ))),
          .just(Mutation.setMoreSectionViewModel(.init(
            section: .init(id: .more, title: "more"),
            items: [.more(list.count - linkList.count)]
          ))),
        ])
      }
  }

  private func fetchNoReadLinks() -> Observable<Mutation> {
    fetchLinkListUseCase.execute(sort: .createAt, order: .desc)
      .asObservable()
      .flatMap { list -> Observable<Mutation> in
        let noReadLinkList = list.filter { $0.readCount == 0 }
        let lastIndex = noReadLinkList.count < 5
          ? noReadLinkList.endIndex
          : noReadLinkList.index(0, offsetBy: 5)
        let linkList = noReadLinkList[noReadLinkList.startIndex..<lastIndex]

        // 링크 자체가 존재 X
        if noReadLinkList.count == 0 {
          return .concat([
            .just(Mutation.setBannerSectionViewModel(.init(
              section: .init(id: .banner, title: "banner"),
              items: [.banner(.init(id: "banner", imageURL: nil, type: .noRead))]
            ))),
            .just(Mutation.setLinkSectionViewModel(nil)),
            .just(Mutation.setMoreSectionViewModel(nil)),
          ])
        }

        // 링크 존재 O , 읽지 않은 링크 존재 O
        return .concat([
          .just(Mutation.setBannerSectionViewModel(.init(
            section: .init(id: .banner, title: "banner"),
            items: [.banner(.init(id: "banner", imageURL: nil, type: .noRead))]
          ))),
          .just(Mutation.setLinkSectionViewModel(.init(
            section: .init(id: .normal, title: "normal"),
            items: linkList.map { link in
              HomeFeedModel.Item.link(.init(
                id: link.id,
                imageURL: link.thumbnailURL,
                linkURL: link.url,
                title: link.title,
                tagList: link.tags,
                date: link.createdAt
              ))
            }
          ))),
          .just(Mutation.setMoreSectionViewModel(.init(
            section: .init(id: .more, title: "more"),
            items: [.more(list.count - linkList.count)]
          ))),
        ])
      }
  }

  private func syncFolderList() -> Observable<Mutation> {
    fetchFolderListUseCase.execute(sort: .createAt)
      .asObservable()
      .flatMap { _ in Observable<Mutation>.empty() }
  }
}
