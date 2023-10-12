//
//  LinkDetailViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/18.
//

import Foundation

import ReactorKit
import RxSwift

import Domain

final class LinkDetailViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case deleteButtonTapped
    case moveFolder(Folder)
    case readLink(String)
  }

  enum Mutation {
    case setDeleted
    case updateLink(Link)
  }

  struct State {
    var link: Link

    var isDeleted = false
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let deleteLinkUseCase: DeleteLinkUseCase
  private let updateLinkWithFolderUseCase: UpdateLinkWithFolderUseCase
  private let readLinkUseCase: ReadLinkUseCase

  // MARK: initializing

  init(
    deleteLinkUseCase: DeleteLinkUseCase,
    updateLinkWithFolderUseCase: UpdateLinkWithFolderUseCase,
    readLinkUseCase: ReadLinkUseCase,
    link: Link
  ) {
    defer { _ = self.state }

    self.deleteLinkUseCase = deleteLinkUseCase
    self.updateLinkWithFolderUseCase = updateLinkWithFolderUseCase
    self.readLinkUseCase = readLinkUseCase

    self.initialState = State(
      link: link
    )
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .deleteButtonTapped:
      return deleteLink()

    case .moveFolder(let folder):
      return updateLink(withFolder: folder)

    case .readLink(let id):
      return readLinkUseCase.execute(id: id)
        .asObservable()
        .flatMap { [weak self] _ -> Observable<Mutation> in
          guard let self else { return .empty() }
          var link = self.currentState.link
          link.readCount += 1
          return .just(Mutation.updateLink(link))
        }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setDeleted:
      newState.isDeleted = true

    case .updateLink(let link):
      newState.link = link
    }

    return newState
  }
}


// MARK: - Private

extension LinkDetailViewReactor {

  private func deleteLink() -> Observable<Mutation> {
    deleteLinkUseCase.execute(id: currentState.link.id)
      .asObservable()
      .flatMap { _ -> Observable<Mutation> in
        .just(Mutation.setDeleted)
      }
  }

  private func updateLink(withFolder folder: Folder) -> Observable<Mutation> {
    updateLinkWithFolderUseCase.execute(
      id: currentState.link.id,
      folderID: folder.id
    )
    .asObservable()
    .flatMap { [weak self] _ -> Observable<Mutation> in
      guard let self else { return .empty() }
      var link = self.currentState.link

      link.folderName = folder.title
      link.linkBookId = folder.id

      return .just(Mutation.updateLink(link))
    }
  }
}
