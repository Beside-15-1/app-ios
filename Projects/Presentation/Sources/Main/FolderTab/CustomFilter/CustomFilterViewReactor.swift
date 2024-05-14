//
//  CustomFilterViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 12/20/23.
//

import Foundation

import ReactorKit
import RxSwift

import Domain
import PBAnalyticsInterface
import PBUserDefaults
import PresentationInterface

final class CustomFilterViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case viewDidLoad
    case viewDidAppear
    case changePeriodType(PeriodType)
    case tagItemTapped(index: Int)
    case selectedTagListRemoveButtonTapped(index: Int)
    case updateCustomPeriod(CustomPeriod)
    case updateUnreadFiltering(Bool)
    case resetButtonTapped
    case confirmButtonTapped
    case closeButtonTapped
  }

  enum Mutation {
    case setTagList([Tag])
    case updateTagList
    case setPeriodType(PeriodType)
    case updateSelectedTag(index: Int)
    case removeSelectedTag(index: Int)
    case setCustomPeriod(CustomPeriod)
    case setUnreadFiltering(Bool)
  }

  struct State {
    // TagList
    var tagList: [Tag] = []
    var selectedTagList: [Tag] = []
    var tagListSectionItems: [CustomFilterTagListView.SectionItem] = []

    // Period
    var periodType: PeriodType
    var customPeriod: CustomPeriod

    // Unread
    var isUnreadFiltering: Bool
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  private let analytics: PBAnalytics
  private let tagRepository: TagRepository

  let initialState: State


  // MARK: initializing

  init(
    analytics: PBAnalytics,
    tagRepository: TagRepository,
    customFilter: CustomFilter?
  ) {
    defer { _ = self.state }

    self.analytics = analytics
    self.tagRepository = tagRepository

    let customFilter = customFilter ?? CustomFilter()

    self.initialState = State(
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
      return .concat([
        fetchTagList(),
        .just(Mutation.updateTagList),
      ])

    case .viewDidAppear:
      analytics.log(type: CustomFilterEvent.shown)
      return .empty()

    case .changePeriodType(let type):
      switch type {
      case .all:
        analytics.log(type: CustomFilterEvent.click(component: .dateAll))
      case .week:
        analytics.log(type: CustomFilterEvent.click(component: .dateWeek))
      case .month:
        analytics.log(type: CustomFilterEvent.click(component: .dateMonth))
      case .custom:
        analytics.log(type: CustomFilterEvent.click(component: .dateCustom))
      }

      return .just(Mutation.setPeriodType(type))

    case .tagItemTapped(let index):
      analytics.log(type: CustomFilterEvent.click(component: .addTag))
      return .concat([
        .just(Mutation.updateSelectedTag(index: index)),
        .just(Mutation.updateTagList),
      ])

    case .selectedTagListRemoveButtonTapped(let index):
      analytics.log(type: CustomFilterEvent.click(component: .deleteTag))
      return .concat([
        .just(Mutation.removeSelectedTag(index: index)),
        .just(Mutation.updateTagList),
      ])

    case .updateCustomPeriod(let period):
      return .just(Mutation.setCustomPeriod(period))

    case .updateUnreadFiltering(let isOn):
      analytics.log(type: CustomFilterEvent.click(component: .toggle))
      return .just(Mutation.setUnreadFiltering(isOn))

    case .resetButtonTapped:
      analytics.log(type: CustomFilterEvent.click(component: .reset))
      return .empty()

    case .confirmButtonTapped:
      analytics.log(type: CustomFilterEvent.click(component: .applyFilter))
      return .empty()

    case .closeButtonTapped:
      analytics.log(type: CustomFilterEvent.click(component: .close))
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setTagList(let tagList):
      newState.tagList = tagList

    case .updateTagList:
      newState.tagListSectionItems = currentState.tagList.map { tag in
        let isSelected = currentState.selectedTagList.contains(where: { tag == $0 })
        return CustomFilterTagListView.SectionItem.normal(.init(tag: tag, isSelected: isSelected))
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


// MARK: - Private

extension CustomFilterViewReactor {

  private func fetchTagList() -> Observable<Mutation> {
    tagRepository.fetchTagList()
      .asObservable()
      .map { Mutation.setTagList($0) }
  }
}
