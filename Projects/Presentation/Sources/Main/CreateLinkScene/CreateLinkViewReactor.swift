import Foundation

import ReactorKit
import RxSwift

import Domain

final class CreateLinkViewReactor: Reactor {

  enum Action {
    case fetchThumbnail(String)
  }

  enum Mutation {
    case setThumbnail(Thumbnail?)
  }

  struct State {
    var thumbnail: Thumbnail?
  }

  // MARK: Properties

  private let fetchThumbnailUseCase: FetchThumbnailUseCase

  private let disposeBag = DisposeBag()

  let initialState: State

  // MARK: initializing

  init(
    fetchThumbnailUseCase: FetchThumbnailUseCase
  ) {
    defer { _ = self.state }
    self.fetchThumbnailUseCase = fetchThumbnailUseCase
    initialState = State()
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetchThumbnail(let url):
      guard let url = URL(string: url) else { return .empty() }

      return fetchThumbnail(url: url)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .setThumbnail(let thumbnail):
      newState.thumbnail = thumbnail
    }

    return newState
  }
}


// MARK: - Private

extension CreateLinkViewReactor {
  private func fetchThumbnail(url: URL) -> Observable<Mutation> {
    fetchThumbnailUseCase.execute(url: url)
      .asObservable()
      .map { Mutation.setThumbnail($0) }
  }
}
