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
import PresentationInterface

final class TagAndPeriodFilterViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case viewDidLoad
    case changePeriodType(PeriodType)
  }

  enum Mutation {
    case updateTagList
    case setPeriodType(PeriodType)
  }

  struct State {
    // TagList
    var tagList: [String]
    var selectedTagList: [String] = []
    var tagListSectionItems: [TagAndPeriodTagListView.SectionItem] = []

    // Period
    var periodType: PeriodType
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  private let userDefaults: UserDefaultsManager

  let initialState: State


  // MARK: initializing

  init(
    userDefaults: UserDefaultsManager,
    periodType: PeriodType
  ) {
    defer { _ = self.state }

    self.userDefaults = userDefaults

    self.initialState = State(
      tagList: userDefaults.tagList,
      periodType: periodType
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

    case .changePeriodType(let type):
      return .just(Mutation.setPeriodType(type))
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

    case .setPeriodType(let type):
      newState.periodType = type
    }

    return newState
  }
}
