//
//  MyPageBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/20.
//

import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

struct MyPageDependency {
  let analytics: PBAnalytics
  let loginRepository: LoginRepository
  let tagRepository: TagRepository
  let manageTagBuilder: ManageTagBuildable
  let webBuilder: PBWebBuildable
  let deleteAccountBuilder: DeleteAccountBuildable
  let pushSettingBuilder: PushSettingBuildable
}

final class MyPageBuilder: MyPageBuildable {

  private let dependency: MyPageDependency
  private var loginBuilder: LoginBuildable?

  init(dependency: MyPageDependency) {
    self.dependency = dependency
  }

  func build(payload: MyPagePayload) -> UIViewController {
    let reactor = MyPageViewReactor(
      logoutUseCase: LogoutUseCaseImpl(
        loginRepository: dependency.loginRepository,
        tagRepository: dependency.tagRepository
      )
    )

    let viewController = MyPageViewController(
      reactor: reactor,
      analytics: dependency.analytics,
      loginBuilder: loginBuilder!,
      manageTagBuilder: dependency.manageTagBuilder,
      webBuilder: dependency.webBuilder,
      deleteAccountBuilder: dependency.deleteAccountBuilder,
      pushSettingBuilder: dependency.pushSettingBuilder
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
