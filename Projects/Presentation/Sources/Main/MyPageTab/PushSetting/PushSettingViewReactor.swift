//
//  PushSettingViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 10/24/23.
//

import Foundation

import ReactorKit
import RxSwift

import Domain

final class PushSettingViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case viewDidLoad
    case updateUnreadAgree(Bool)
    case updateUnclassifyAgree(Bool)
  }

  enum Mutation {
    case setConfig(PushSettingConfig)
  }

  struct State {
    var config = PushSettingConfig(isClassifyAgree: false, isReadAgree: false)
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let pushRepository: PushRepository


  // MARK: initializing

  init(
    pushRepository: PushRepository
  ) {
    defer { _ = self.state }

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
      return fetchPushSettingConfig()

    case .updateUnreadAgree(let isAgree):
      return updateUnreadAgree(isAgree: isAgree)

    case .updateUnclassifyAgree(let isAgree):
      return updateUnclassifyAgree(isAgree: isAgree)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setConfig(let pushSettingConfig):
      newState.config = pushSettingConfig
    }

    return newState
  }
}


// MARK: - Private

extension PushSettingViewReactor {

  private func fetchPushSettingConfig() -> Observable<Mutation> {
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
