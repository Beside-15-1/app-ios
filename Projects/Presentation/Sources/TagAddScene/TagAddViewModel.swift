import Foundation

import RxSwift

// MARK: - TagAddViewModelInput

protocol TagAddViewModelInput {}

// MARK: - TagAddViewModelOutput

protocol TagAddViewModelOutput {}

// MARK: - TagAddViewModel

final class TagAddViewModel: TagAddViewModelOutput {
  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: initializing

  init() {}

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Output
}

// MARK: TagAddViewModelInput

extension TagAddViewModel: TagAddViewModelInput {}
