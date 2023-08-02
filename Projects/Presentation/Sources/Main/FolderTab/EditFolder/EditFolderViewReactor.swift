//
//  EditFolderViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/14.
//

import Foundation

import ReactorKit
import RxSwift

import Domain

final class EditFolderViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {}

  enum Mutation {}

  struct State {
    let folder: Folder
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State


  // MARK: initializing

  init(
    folder: Folder
  ) {
    defer { _ = self.state }
    initialState = State(
      folder: folder
    )
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {}

  func reduce(state: State, mutation: Mutation) -> State {}
}
