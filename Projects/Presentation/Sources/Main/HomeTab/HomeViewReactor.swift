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
    case createLinkSucceed
  }

  enum Mutation {
    case setLinkList([Link])
    case setLinkViewModel(HomeLinkSectionViewModel)
    case setFolderList([Folder])
    case setFolderViewModel(HomeFolderSectionViewModel)
  }

  struct State {
    var linkList: [Link] = []
    var linkViewModel: HomeLinkSectionViewModel?

    var folderList: [Folder] = []
    var folderViewModel: HomeFolderSectionViewModel?
  }


  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let fetchLinkListUseCase: FetchAllLinksUseCase
  private let fetchFolderListUseCase: FetchFolderListUseCase
  private let getMeUseCase: GetMeUseCase


  // MARK: initializing

  init(
    fetchLinkListUseCase: FetchAllLinksUseCase,
    fetchFolderListUseCase: FetchFolderListUseCase,
    getMeUseCase: GetMeUseCase
  ) {
    defer { _ = self.state }

    self.fetchLinkListUseCase = fetchLinkListUseCase
    self.fetchFolderListUseCase = fetchFolderListUseCase
    self.getMeUseCase = getMeUseCase

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
        fetchLinkList(),
        fetchFolderList(),
        getMe(),
      ])

    case .createFolderSucceed:
      return fetchFolderList()

    case .createLinkSucceed:
      return fetchLinkList()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setLinkList(let linkList):
      newState.linkList = linkList

    case .setLinkViewModel(let viewModel):
      newState.linkViewModel = viewModel

    case .setFolderList(let folderList):
      newState.folderList = folderList

    case .setFolderViewModel(let viewModel):
      newState.folderViewModel = viewModel
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
          .just(Mutation.setFolderViewModel(viewModel)),
        ])
      }
  }

  private func fetchLinkList() -> Observable<Mutation> {
    fetchLinkListUseCase.execute(sort: .createAt, order: .asc)
      .asObservable()
      .flatMap { linkList -> Observable<Mutation> in
        let lastIndex = linkList.count < 5 ? linkList.endIndex : linkList.index(0, offsetBy: 5)
        let linkList = linkList.reversed()[linkList.startIndex..<lastIndex]

        var viewModel = HomeLinkSectionViewModel(
          section: .normal,
          items: linkList.map {
            .init(
              id: $0.id,
              imageURL: $0.thumbnailURL,
              title: $0.title,
              tag: $0.tags.map { tag in
                ["#", tag, " "].joined()
              }.reduce("") { first, second in first + second },
              date: $0.createdAt,
              isMore: false
            )
          }
        )

        viewModel.items.append(.init(id: "", imageURL: nil, title: "", tag: "", date: "", isMore: true))

        return .concat([
          .just(Mutation.setLinkList(linkList.reversed())),
          .just(Mutation.setLinkViewModel(viewModel)),
        ])
      }
  }

  private func getMe() -> Observable<Mutation> {
    getMeUseCase.execute()
      .asObservable()
      .flatMap { _ -> Observable<Mutation> in .empty() }
  }
}
