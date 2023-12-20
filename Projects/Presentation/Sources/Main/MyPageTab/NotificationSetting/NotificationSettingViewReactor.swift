//
//  NotificationSettingViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 10/24/23.
//

import Foundation

import ReactorKit
import RxSwift

import Domain
import PBAnalyticsInterface

final class NotificationSettingViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case viewDidLoad
    case viewDidAppear
    case updateUnreadAgree(Bool)
    case updateUnclassifyAgree(Bool)
  }

  enum Mutation {
    case setConfig(NotificationSettingConfig)
  }

  struct State {
    var config = NotificationSettingConfig(isClassifyAgree: false, isReadAgree: false)
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let analytics: PBAnalytics

  private let pushRepository: PushRepository


  // MARK: initializing

  init(
    analytics: PBAnalytics,
    pushRepository: PushRepository
  ) {
    defer { _ = self.state }

    self.analytics = analytics
    self.pushRepository = pushRepository

    self.initialState = State()
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return fetchNotificationSettingConfig()

    case .viewDidAppear:
      analytics.log(type: NotificationSettingEvent.shown)
      return .empty()

    case .updateUnreadAgree(let isAgree):
      if isAgree {
        analytics.log(type: NotificationSettingEvent.click(component: .unreadOn))
      } else {
        analytics.log(type: NotificationSettingEvent.click(component: .unreadOff))
      }
      return updateUnreadAgree(isAgree: isAgree)

    case .updateUnclassifyAgree(let isAgree):
      if isAgree {
        analytics.log(type: NotificationSettingEvent.click(component: .unclassifiedOn))
      } else {
        analytics.log(type: NotificationSettingEvent.click(component: .unclassifiedOff))
      }
      return updateUnclassifyAgree(isAgree: isAgree)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setConfig(let NotificationSettingConfig):
      newState.config = NotificationSettingConfig
    }

    return newState
  }
}


// MARK: - Private

extension NotificationSettingViewReactor {

  private func fetchNotificationSettingConfig() -> Observable<Mutation> {
    pushRepository.fetchSetting()
      .asObservable()
      .map { Mutation.setConfig($0) }
  }

  private func updateUnreadAgree(isAgree: Bool) -> Observable<Mutation> {
    let currentConfig = currentState.config

    return pushRepository.updateSetting(isClassifyAgree: currentConfig.isClassifyAgree, isReadAgree: isAgree)
      .asObservable()
      .map { Mutation.setConfig(.init(isClassifyAgree: currentConfig.isClassifyAgree, isReadAgree: isAgree)) }
      .catch { _ in .just(Mutation.setConfig(currentConfig)) }
  }

  private func updateUnclassifyAgree(isAgree: Bool) -> Observable<Mutation> {
    let currentConfig = currentState.config

    return pushRepository.updateSetting(isClassifyAgree: isAgree, isReadAgree: currentConfig.isReadAgree)
      .asObservable()
      .map { Mutation.setConfig(.init(isClassifyAgree: isAgree, isReadAgree: currentConfig.isReadAgree)) }
      .catch { _ in .just(Mutation.setConfig(currentConfig)) }
  }
}
