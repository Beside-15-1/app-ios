import Foundation
import UIKit

import ReactorKit
import RxSwift

import Domain

final class CreateLinkViewReactor: Reactor {

  enum Action {
    case viewDidLoad
    case viewDidAppear
    case fetchThumbnail(String)
    case updateTitle(String)
    case updateFolder(Folder)
    case updateTag([String])
    case updateFolderList
    case saveButtonTapped
    case inputURL(String)
    case createFolderSucceed(Folder)
  }

  enum Mutation {
    case setThumbnail(Thumbnail?)
    case setLinkError(String)
    case setTitleError(String?)
    case setFolder(Folder)
    case setTag([String])
    case setFolderList([Folder])
    case setSucceed(Link)
    case setInputURL(String)
    case setLoading(Bool)
  }

  struct State {
    var inputURL = ""

    var link: Link?
    var thumbnail: Thumbnail?
    var folder: Folder?
    var tags: [String] = []
    var folderList: [Folder] = []

    var isSaveButtonEnabled: Bool {
      guard !inputURL.isEmpty else { return false }

      guard let thumbnail,
            let title = thumbnail.title,
            let url = thumbnail.url,
            !title.isEmpty else {
        return false
      }

      if inputURL != url {
        return false
      }

      return true
    }

    @Pulse var linkError: String?
    @Pulse var titleError: String?
    var isSucceed: Link?

    var isLoading = false
  }

  // MARK: Properties

  private let fetchThumbnailUseCase: FetchThumbnailUseCase
  private let fetchFolderListUseCase: FetchFolderListUseCase
  private let createLinkUseCase: CreateLinkUseCase
  private let updateLinkUseCase: UpdateLinkUseCase

  private let pasteboard: UIPasteboard

  private let disposeBag = DisposeBag()

  let initialState: State

  private var shouldValidateClipboard = true

  // MARK: initializing

  init(
    fetchThumbnailUseCase: FetchThumbnailUseCase,
    fetchFolderListUseCase: FetchFolderListUseCase,
    createLinkUseCase: CreateLinkUseCase,
    updateLinkUseCase: UpdateLinkUseCase,
    pasteboard: UIPasteboard,
    link: Link?
  ) {
    defer { _ = self.state }
    self.fetchThumbnailUseCase = fetchThumbnailUseCase
    self.fetchFolderListUseCase = fetchFolderListUseCase
    self.createLinkUseCase = createLinkUseCase
    self.updateLinkUseCase = updateLinkUseCase
    self.pasteboard = pasteboard

    self.initialState = State(
      link: link,
      thumbnail: link == nil ? nil : Thumbnail(title: link?.title, url: link?.url, imageURL: link?.thumbnailURL),
      tags: link == nil ? [] : link?.tags ?? []
    )
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return fetchFolderList()

    case .viewDidAppear:
      if shouldValidateClipboard,
         currentState.link == nil {
        shouldValidateClipboard = false
        return validateClipboard()
      }

      return .empty()

    case .fetchThumbnail(let url):
      return .concat([
        .just(Mutation.setLoading(true)),
        fetchThumbnail(url: url),
        .just(Mutation.setLoading(false)),
      ])

    case .updateTitle(let title):
      guard !title.isEmpty else {
        var thumbnail = currentState.thumbnail
        thumbnail?.title = nil

        return .concat([
          .just(Mutation.setThumbnail(thumbnail)),
          .just(Mutation.setTitleError("제목은 1 글자 이상 입력해주세요.")),
        ])
      }

      var thumbnail = currentState.thumbnail
      thumbnail?.title = title

      return .concat([
        .just(Mutation.setThumbnail(thumbnail)),
        .just(Mutation.setTitleError(nil)),
      ])

    case .updateFolder(let folder):
      return .just(Mutation.setFolder(folder))

    case .updateTag(let tags):
      return .just(Mutation.setTag(tags))

    case .updateFolderList:
      return fetchFolderList()

    case .saveButtonTapped:
      return saveLink()

    case .inputURL(let url):
      guard !url.isEmpty else {
        return .concat([
          .just(Mutation.setThumbnail(nil)),
          .just(Mutation.setInputURL(url)),
        ])
      }
      return .just(Mutation.setInputURL(url))

    case .createFolderSucceed(let folder):
      return fetchFolderListAndSetFolder(folder: folder)
    }
  }

  private func fetchFolderListAndSetFolder(folder: Folder) -> Observable<Mutation> {
    fetchFolderListUseCase.execute(sort: .createAt)
      .asObservable()
      .flatMap { folderList -> Observable<Mutation> in
        .concat([
          .just(Mutation.setFolderList(folderList.folders)),
          .just(Mutation.setFolder(folder)),
        ])
      }
      .catch { _ in
        .just(Mutation.setFolder(folder))
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

    case .setSucceed(let link):
      newState.isSucceed = link

    case .setInputURL(let url):
      newState.inputURL = url

    case .setTitleError(let error):
      newState.titleError = error

    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    }

    return newState
  }
}


// MARK: - Private

extension CreateLinkViewReactor {
  private func fetchThumbnail(url: String) -> Observable<Mutation> {
    fetchThumbnailUseCase.execute(url: url)
      .asObservable()
      .flatMap { thumbnail -> Observable<Mutation> in
        .concat([
          .just(Mutation.setThumbnail(thumbnail)),
          .just(Mutation.setInputURL(thumbnail.url ?? "")),
        ])
      }
      .catch { _ in
        .just(Mutation.setLinkError("유효한 링크를 입력해주세요."))
      }
  }

  private func fetchFolderList() -> Observable<Mutation> {
    fetchFolderListUseCase.execute(sort: .createAt)
      .asObservable()
      .flatMap { [weak self] folderList -> Observable<Mutation> in
        guard let self else { return .empty() }

        if let folder = folderList.folders.first(where: { $0.id == self.currentState.link?.linkBookId }) {
          return .concat([
            .just(Mutation.setFolderList(folderList.folders)),
            .just(Mutation.setFolder(folder)),
          ])
        }

        return .concat([
          .just(Mutation.setFolderList(folderList.folders)),
          .just(Mutation.setFolder(folderList.folders.first!)),
        ])
      }
  }

  private func saveLink() -> Observable<Mutation> {
    guard let folder = currentState.folder,
          let thumbnail = currentState.thumbnail else {
      return .empty()
    }

    if let link = currentState.link {
      // 편집
      return updateLinkUseCase.execute(
        id: link.id,
        title: thumbnail.title ?? "",
        url: lowercaseComponentsInURL(thumbnail.url ?? "") ?? thumbnail.url ?? "",
        thumbnailURL: thumbnail.imageURL,
        tags: currentState.tags
      )
      .asObservable()
      .map { Mutation.setSucceed($0) }

    } else {
      // 생성
      return createLinkUseCase.execute(
        linkBookId: folder.id,
        title: thumbnail.title ?? "",
        url: lowercaseComponentsInURL(thumbnail.url ?? "") ?? thumbnail.url ?? "",
        thumbnailURL: thumbnail.imageURL,
        tags: currentState.tags
      )
      .asObservable()
      .map { Mutation.setSucceed($0) }
    }
  }

  private func validateClipboard() -> Observable<Mutation> {
    let url = pasteboard.string ?? ""

    if url.hasPrefix("https") || url.hasPrefix("http") {
      return .concat([
        .just(Mutation.setLoading(true)),
        fetchThumbnail(url: url),
        .just(Mutation.setLoading(false)),
      ])
    }

    return .empty()
  }

  private func lowercaseComponentsInURL(_ urlString: String) -> String? {
    // 주어진 문자열을 URL로 변환
    if let url = URL(string: urlString) {
      // URL의 다른 구성 요소를 가져옴
      // URL의 경로(path)를 제외한 나머지 구성 요소를 소문자로 변환
      let lowercaseHost = url.host?.lowercased()
      let lowercaseScheme = url.scheme?.lowercased()
      let lowercaseFragment = url.fragment?.lowercased()

      // 소문자로 변환한 구성 요소와 경로를 결합하여 새 URL을 생성
      var components = URLComponents()
      components.scheme = lowercaseScheme
      components.host = lowercaseHost
      components.port = url.port
      components.path = url.path
      components.query = url.query
      components.fragment = lowercaseFragment

      if let newURL = components.url {
        return newURL.absoluteString
      }
    }

    return nil
  }
}
