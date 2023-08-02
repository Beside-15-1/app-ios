//
//  SelectFolderViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/04.
//

import Foundation

import ReactorKit
import RxSwift

import Domain

final class SelectFolderViewReactor: Reactor {

  enum Action {}

  enum Mutation {}

  struct State {
    let folders: [Folder]
    let selectedFolder: Folder?
  }


  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State


  // MARK: initializing

  init(
    folders: [Folder],
    selectedFolder: Folder?
  ) {
    defer { _ = self.state }
    initialState = State(
      folders: folders,
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
