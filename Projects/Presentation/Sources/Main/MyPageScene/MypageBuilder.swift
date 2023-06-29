import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - MyPageDependency

struct MyPageDependency {
  let loginRepository: LoginRepository
  let tagAddBuilder: TagAddBuildable
}

// MARK: - MyPageBuilder

final class MyPageBuilder: MyPageBuildable {
  private let dependency: MyPageDependency
  private var loginBuilder: LoginBuildable?

  init(dependency: MyPageDependency) {
    self.dependency = dependency
  }

  func build(payload: MyPagePayload) -> UIViewController {
    let viewModel = MyPageViewModel(
      logoutUseCase: LogoutUseCaseImpl(loginRepository: dependency.loginRepository)
    )

    let viewController = MyPageViewController(
      viewModel: viewModel,
      loginBuilder: loginBuilder!,
      tagAddBuilder: dependency.tagAddBuilder
    )

    return viewController
  }

  /*
   LoginBuilder가 MainTabBarBuildable의존성을 갖고 있고,
   MyPageBuilder가 LoginBuildable의존성을 갖고 있어 의존성 순환이 발생해요
   PresentAssembly registerMyPageBuidler에서 initComplete를 통해 순환싸이클 문제를 해결해요
    */
  func configure(loginBuilder: LoginBuildable) {
    self.loginBuilder = loginBuilder
  }
}
