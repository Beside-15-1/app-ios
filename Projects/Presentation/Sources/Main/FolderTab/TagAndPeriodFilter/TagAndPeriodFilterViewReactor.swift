//
//  TagAndPeriodFilterViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 12/20/23.
//

import Foundation

import ReactorKit
import RxSwift

import Domain
import PBUserDefaults
import PresentationInterface

final class TagAndPeriodFilterViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case viewDidLoad
    case changePeriodType(PeriodType)
    case tagItemTapped(index: Int)
    case selectedTagListRemoveButtonTapped(index: Int)
    case updateCustomPeriod(CustomPeriod)
    case updateUnreadFiltering(Bool)
  }

  enum Mutation {
    case updateTagList
    case setPeriodType(PeriodType)
    case updateSelectedTag(index: Int)
    case removeSelectedTag(index: Int)
    case setCustomPeriod(CustomPeriod)
    case setUnreadFiltering(Bool)
  }

  struct State {
    // TagList
    var tagList: [String]
    var selectedTagList: [String] = []
    var tagListSectionItems: [TagAndPeriodTagListView.SectionItem] = []

    // Period
    var periodType: PeriodType
    var customPeriod: CustomPeriod

    // Unread
    var isUnreadFiltering: Bool
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  private let userDefaults: UserDefaultsManager

  let initialState: State


  // MARK: initializing

  init(
    userDefaults: UserDefaultsManager,
    customFilter: CustomFilter?
  ) {
    defer { _ = self.state }

    self.userDefaults = userDefaults

    let customFilter = customFilter ?? CustomFilter()

    self.initialState = State(
      tagList: userDefaults.tagList,
      selectedTagList: customFilter.selectedTagList,
      periodType: customFilter.periodType,
      customPeriod: customFilter.customPeriod,
      isUnreadFiltering: customFilter.isUnreadFiltering
    )
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return .just(Mutation.updateTagList)

    case .changePeriodType(let type):
      return .just(Mutation.setPeriodType(type))

    case .tagItemTapped(let index):
      return .concat([
        .just(Mutation.updateSelectedTag(index: index)),
        .just(Mutation.updateTagList),
      ])

    case .selectedTagListRemoveButtonTapped(let index):
      return .concat([
        .just(Mutation.removeSelectedTag(index: index)),
        .just(Mutation.updateTagList),
      ])

    case .updateCustomPeriod(let period):
      return .just(Mutation.setCustomPeriod(period))

    case .updateUnreadFiltering(let isOn):
      return .just(Mutation.setUnreadFiltering(isOn))
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

    case .updateSelectedTag(let index):
      if currentState.selectedTagList.contains(where: { $0 == currentState.tagList[index] }) {
        // deselect
        newState.selectedTagList.removeAll(where: { $0 == currentState.tagList[index] })
      } else {
        // select
        if currentState.selectedTagList.count < 10 {
          newState.selectedTagList.append(currentState.tagList[index])
        }
      }

    case .removeSelectedTag(let index):
      newState.selectedTagList.removeAll(where: { $0 == currentState.selectedTagList[index] })

    case .setCustomPeriod(let period):
      newState.customPeriod = period

    case .setUnreadFiltering(let isOn):
      newState.isUnreadFiltering = isOn
    }

    return newState
  }
}
