import Foundation

import ReactorKit
import RxSwift

import Domain

final class CreateLinkViewReactor: Reactor {

  enum Action {
    case viewDidLoad
    case fetchThumbnail(String)
    case updateTitle(String)
    case updateFolder(Folder)
    case updateTag([String])
  }

  enum Mutation {
    case setThumbnail(Thumbnail?)
    case setLinkError(String)
    case setFolder(Folder)
    case setTag([String])
    case setFolderList([Folder])
  }

  struct State {
    var thumbnail: Thumbnail?
    var folder: Folder?
    var tags: [String] = []
    var folderList: [Folder] = []

    var isSaveButtonEnabled: Bool {
      guard let thumbnail,
            let title = thumbnail.title,
            !title.isEmpty else {
        return false
      }

      return true
    }

    @Pulse var linkError: String?
  }

  // MARK: Properties

  private let fetchThumbnailUseCase: FetchThumbnailUseCase
  private let fetchFolderListUseCase: FetchFolderListUseCase

  private let disposeBag = DisposeBag()

  let initialState: State

  // MARK: initializing

  init(
    fetchThumbnailUseCase: FetchThumbnailUseCase,
    fetchFolderListUseCase: FetchFolderListUseCase
  ) {
    defer { _ = self.state }
    self.fetchThumbnailUseCase = fetchThumbnailUseCase
    self.fetchFolderListUseCase = fetchFolderListUseCase
    self.initialState = State()
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return fetchFolderList()

    case .fetchThumbnail(let url):
      guard let url = URL(string: url) else { return .empty() }

      return fetchThumbnail(url: url)

    case .updateTitle(let title):
      var thumbnail = currentState.thumbnail
      thumbnail?.title = title

      return .just(Mutation.setThumbnail(thumbnail))

    case .updateFolder(let folder):
      return .just(Mutation.setFolder(folder))

    case .updateTag(let tags):
      return .just(Mutation.setTag(tags))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setThumbnail(let thumbnail):
      newState.thumbnail = thumbnail

    case .setFolder(let folder):
      newState.folder = folder

    case .setLinkError(let error):
      newState.linkError = error

    case .setTag(let tags):
      newState.tags = tags

    case .setFolderList(let list):
      newState.folderList = list
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
      .catch { _ in
        .just(Mutation.setLinkError("올바른 링크를 입력하세요"))
      }
  }

  private func fetchFolderList() -> Observable<Mutation> {
    fetchFolderListUseCase.execute(sort: .createAt)
      .asObservable()
      .flatMap { [weak self] folderList -> Observable<Mutation> in
        guard let self else { return .empty() }
        guard let _ = self.currentState.folder else {
          return .concat([
            .just(Mutation.setFolderList(folderList.reversed())),
            .just(Mutation.setFolder(folderList.reversed().first!))
          ])
        }

        return .just(Mutation.setFolderList(folderList.reversed()))
      }
  }
}
