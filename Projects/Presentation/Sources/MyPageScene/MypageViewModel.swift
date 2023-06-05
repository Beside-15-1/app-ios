import Foundation

import RxRelay
import RxSwift

import Domain

// MARK: - MyPageViewModelInput

protocol MyPageViewModelInput {
  func logoutButtonTapped()
}

// MARK: - MyPageViewModelOutput

protocol MyPageViewModelOutput {
  var isLogoutSuccess: PublishRelay<Bool> { get }
}

// MARK: - MyPageViewModel

final class MyPageViewModel: MyPageViewModelOutput {
  // MARK: Properties

  private let logoutUseCase: LogoutUseCase

  private let disposeBag = DisposeBag()

  // MARK: initializing

  init(
    logoutUseCase: LogoutUseCase
  ) {
    self.logoutUseCase = logoutUseCase
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Output

  var isLogoutSuccess: PublishRelay<Bool> = .init()
}

// MARK: MyPageViewModelInput

extension MyPageViewModel: MyPageViewModelInput {
  func logoutButtonTapped() {
    logoutUseCase.excute()
      .asObservable()
      .bind(to: isLogoutSuccess)
      .disposed(by: disposeBag)
  }
}
