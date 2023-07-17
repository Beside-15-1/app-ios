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

  enum Action {}

  enum Mutation {}

  struct State {
    let folderList: [Folder]
    let selectedFolder: Folder
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State


  // MARK: initializing

  init(
    folderList: [Folder],
    selectedFolder: Folder
  ) {
    defer { _ = self.state }

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

  func mutate(action: Action) -> Observable<Mutation> {}

  func reduce(state: State, mutation: Mutation) -> State {}
}
