import Foundation

import RxSwift

// MARK: - TermsOfUseViewModelInput

protocol TermsOfUseViewModelInput {}

// MARK: - TermsOfUseViewModelOutput

protocol TermsOfUseViewModelOutput {}

// MARK: - TermsOfUseViewModel

final class TermsOfUseViewModel: TermsOfUseViewModelOutput {
  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: initializing

  init() {}

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Output
}

// MARK: TermsOfUseViewModelInput

extension TermsOfUseViewModel: TermsOfUseViewModelInput {}
