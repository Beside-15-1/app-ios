//
//  ShareViewReactor.swift
//  ShareExtension
//
//  Created by 박천송 on 2023/08/17.
//

import Foundation

import KeychainAccess
import ReactorKit
import RxSwift

import Data
import Domain

final class ShareViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case viewDidLoad
    case fetchThumbnail(URL)
    case retryFetchThumbnail
    case updateFolder(Folder)
    case updateTitle(String)
  }

  enum Mutation {
    case setLink(Link)
    case setStatus(ShareStatus)
    case setURL(URL)
    case setFolderList([Folder])
  }

  struct State {
    var link: Link?
    var status: ShareStatus = .loading
    var url: URL?
    var folderList: [Folder] = []
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let repository: Repository = .init()
  private let fetchThumbnailUseCase = FetchThumbnailUseCase(metadataProvider: .init())


  // MARK: initializing

  init() {
    defer { _ = self.state }
    self.initialState = State()
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      guard let _ = Keychain(service: "com.pinkboss.joosum")["accessToken"] else {
        return .just(Mutation.setStatus(.needLogin))
      }

      return fetchFolderList()

    case .fetchThumbnail(let url):
      return .concat([
        .just(Mutation.setURL(url)),
        .just(Mutation.setStatus(.loading)),
        fetchThumbnailAndCreateLink(url: url),
      ])

    case .retryFetchThumbnail:
      guard let url = currentState.url else { return .empty() }
      return .concat([
        .just(Mutation.setStatus(.loading)),
        fetchThumbnailAndCreateLink(url: url),
      ])

    case .updateFolder(let folder):
      guard var link = currentState.link else { return .empty() }

      link.folderName = folder.title
      link.linkBookId = folder.id

      return updateFolder(link: link)

    case .updateTitle(let title):
      guard var link = currentState.link else { return .empty() }

      link.title = title

      return updateLink(link: link)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setLink(let link):
      newState.link = link

    case .setStatus(let status):
      newState.status = status

    case .setURL(let url):
      newState.url = url

    case .setFolderList(let folderList):
      newState.folderList = folderList
    }

    return newState
  }
}


// MARK: - Private

extension ShareViewReactor {

  private func fetchFolderList() -> Observable<Mutation> {
    repository.fetchFolderList()
      .asObservable()
      .map { Mutation.setFolderList($0.folders) }
  }

  private func fetchThumbnailAndCreateLink(url: URL) -> Observable<Mutation> {
    fetchThumbnailUseCase.execute(url: url)
      .asObservable()
      .flatMap { [weak self] thumbnail -> Observable<Mutation> in
        guard let self else { return .empty() }

        return createLink(url: url, thumbnail: thumbnail)
      }
  }

  private func createLink(url: URL, thumbnail: Thumbnail?) -> Observable<Mutation> {
    repository.createLink(
      linkBookId: "",
      title: thumbnail?.title ?? "",
      url: thumbnail?.url ?? url.absoluteString,
      thumbnailURL: thumbnail?.imageURL,
      tags: []
    )
    .asObservable()
    .flatMap { link -> Observable<Mutation> in
      .concat([
        .just(Mutation.setLink(link)),
        .just(Mutation.setStatus(.success)),
      ])
    }
    .catch { _ in
      .just(Mutation.setStatus(.failure))
    }
  }

  private func updateFolder(link: Link) -> Observable<Mutation> {
    repository.updateLink(id: link.id, folderID: link.linkBookId)
      .asObservable()
      .flatMap { _ -> Observable<Mutation> in
        .just(Mutation.setLink(link))
      }
  }

  private func updateLink(link: Link) -> Observable<Mutation> {
    repository.updateLink(
      id: link.id,
      title: link.title,
      url: link.url,
      thumbnailURL: link.thumbnailURL,
      tags: link.tags
    )
    .asObservable()
    .flatMap { _ -> Observable<Mutation> in
      .just(Mutation.setLink(link))
    }
  }
}
