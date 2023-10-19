import Foundation

import RxRelay
import RxSwift

import PBAnalyticsInterface

protocol TermsOfUseViewModelInput {
  func allCheckButtonTapped()
  func serviceCheckButtonTapped()
  func personalCheckButtonTapped()
}

protocol TermsOfUseViewModelOutput {
  var isAllSelected: BehaviorRelay<Bool> { get }
  var isServiceSelected: BehaviorRelay<Bool> { get }
  var isPersonalSelected: BehaviorRelay<Bool> { get }
}

final class TermsOfUseViewModel: TermsOfUseViewModelOutput {

  // MARK: Properties

  private let disposeBag = DisposeBag()

  private let analytics: PBAnalytics


  // MARK: initializing

  init(
    analytics: PBAnalytics
  ) {
    self.analytics = analytics
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Output

  var isAllSelected: BehaviorRelay<Bool> = .init(value: false)
  var isServiceSelected: BehaviorRelay<Bool> = .init(value: false)
  var isPersonalSelected: BehaviorRelay<Bool> = .init(value: false)
}

// MARK: TermsOfUseViewModelInput

extension TermsOfUseViewModel: TermsOfUseViewModelInput {
  func allCheckButtonTapped() {
    let newValue = !isAllSelected.value

    analytics.log(type: TermsEvent.click(component: .checkAll))

    if newValue {
      isAllSelected.accept(true)
      isServiceSelected.accept(true)
      isPersonalSelected.accept(true)
    } else {
      isAllSelected.accept(false)
      isServiceSelected.accept(false)
      isPersonalSelected.accept(false)
    }
  }

  func serviceCheckButtonTapped() {
    let newValue = !isServiceSelected.value

    isServiceSelected.accept(newValue)
    analytics.log(type: TermsEvent.click(component: .checkTermsOfService))

    if newValue, isPersonalSelected.value {
      isAllSelected.accept(true)
    } else {
      isAllSelected.accept(false)
    }
  }

  func personalCheckButtonTapped() {
    let newValue = !isPersonalSelected.value

    isPersonalSelected.accept(newValue)
    analytics.log(type: TermsEvent.click(component: .checkPrivacyPolicy))

    if newValue, isServiceSelected.value {
      isAllSelected.accept(true)
    } else {
      isAllSelected.accept(false)
    }
  }
}
