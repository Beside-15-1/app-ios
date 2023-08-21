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
    case fetchThumbnaiil(URL)
  }

  enum Mutation {
    case setLink(Link)
    case setStatus(ShareStatus)
  }

  struct State {
    var link: Link?
    var status: ShareStatus = .loading
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

      return .empty()

    case .fetchThumbnaiil(let url):
      return .concat([
        .just(Mutation.setStatus(.loading)),
        fetchThumbnailAndCreateLink(url: url),
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setLink(let link):
      newState.link = link

    case .setStatus(let status):
      newState.status = status
    }

    return newState
  }
}


// MARK: - Private

extension ShareViewReactor {

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
}
