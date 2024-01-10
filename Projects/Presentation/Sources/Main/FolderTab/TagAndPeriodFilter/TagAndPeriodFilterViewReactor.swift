//
//  TagAndPeriodFilterViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 12/20/23.
//

import Foundation

import ReactorKit
import RxSwift

import PBUserDefaults

final class TagAndPeriodFilterViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case viewDidLoad
  }

  enum Mutation {
    case updateTagList
  }

  struct State {
    var tagList: [String]
    var selectedTagList: [String] = []

    var tagListSectionItems: [TagAndPeriodTagListView.SectionItem] = []
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  private let userDefaults: UserDefaultsManager

  let initialState: State


  // MARK: initializing

  init(
    userDefaults: UserDefaultsManager
  ) {
    defer { _ = self.state }

    self.userDefaults = userDefaults

    self.initialState = State(
      tagList: userDefaults.tagList
    )
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return .concat([
        .just(Mutation.updateTagList),
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .updateTagList:
      newState.tagListSectionItems = currentState.tagList.map { tag in
        let isSelected = currentState.selectedTagList.contains(where: { tag == $0 })
        return TagAndPeriodTagListView.SectionItem.normal(.init(tag: tag, isSelected: isSelected))
      }
    }

    return newState
  }
}
