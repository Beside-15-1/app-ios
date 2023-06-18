import Foundation

import RxSwift

// MARK: - LinkBookViewModelInput

protocol LinkBookViewModelInput {}

// MARK: - LinkBookViewModelOutput

protocol LinkBookViewModelOutput {}

// MARK: - LinkBookViewModel

final class LinkBookViewModel: LinkBookViewModelOutput {
  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: initializing

  init() {}

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Output
}

// MARK: LinkBookViewModelInput

extension LinkBookViewModel: LinkBookViewModelInput {}
