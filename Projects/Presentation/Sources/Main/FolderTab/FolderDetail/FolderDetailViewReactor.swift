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
  }

  enum Mutation {
    case setLinkList([Link])
    case setViewModel(FolderDetailSectionViewModel)
  }

  struct State {
    let folderList: [Folder]
    let selectedFolder: Folder

    var linkList: [Link] = []

    var viewModel: FolderDetailSectionViewModel?
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
        return fetchAllLinks()
      } else {
        return fetchLinksInFolder(id: currentState.selectedFolder.id)
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
    }

    return newState
  }
}


// MARK: - Private

extension FolderDetailViewReactor {

  private func fetchAllLinks() -> Observable<Mutation> {
    fetchAllLinkUseCase.execute()
      .asObservable()
      .flatMap { links -> Observable<Mutation> in
        let viewModel = FolderDetailSectionViewModel(
          section: .normal,
          items: links.map {
            .init(
              id: $0.id,
              title: $0.title,
              tags: $0.tags,
              thumbnailURL: $0.thumbnailURL,
              url: $0.url,
              createAt: $0.createdAt,
              folderName: $0.folderName,
              isAll: true
            )
          }
        )

        return .concat([
          .just(Mutation.setLinkList(links)),
          .just(Mutation.setViewModel(viewModel))
        ])
      }
  }

  private func fetchLinksInFolder(id: String) -> Observable<Mutation> {
    fetchLinkInFolderUseCase.execute(linkBookId: id)
      .asObservable()
      .flatMap { links -> Observable<Mutation> in
        let viewModel = FolderDetailSectionViewModel(
          section: .normal,
          items: links.map {
            .init(
              id: $0.id,
              title: $0.title,
              tags: $0.tags,
              thumbnailURL: $0.thumbnailURL,
              url: $0.url,
              createAt: $0.createdAt,
              folderName: $0.folderName,
              isAll: true
            )
          }
        )

        return .concat([
          .just(Mutation.setLinkList(links)),
          .just(Mutation.setViewModel(viewModel))
        ])
      }
  }
}
