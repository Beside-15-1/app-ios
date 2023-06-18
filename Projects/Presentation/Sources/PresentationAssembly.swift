import Foundation

import Swinject

import Domain
import PresentationInterface

// MARK: - PresentationAssembly

public final class PresentationAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    let registerFunctions: [(Container) -> Void] = [
      registerLoginBuilder,
      registerMainTabBuilder,
      registerLinkBookBuilder,
      registerHomeBuilder,
      registerFolderBuilder,
      registerMyPageBuilder,
      registerSignUpBuilder,
      registerTermsOfUseBuilder,
      registerTagAddBuilder,
      registerCreateLinkBuilder,
      registerSelectFolderBuilder,
      registerSignUpBuilder
    ]

    registerFunctions.forEach { function in
      function(container)
    }
  }

  private func registerLoginBuilder(container: Container) {
    container.register(LoginBuildable.self) { r in
      LoginBuilder(dependency: .init(
        analytics: r.resolve(),
        loginRepository: r.resolve(),
        mainTabBuilder: r.resolve(),
        signUpBuilder: r.resolve(),
        termsOfUseBuilder: r.resolve()
      ))
    }
  }

  private func registerMainTabBuilder(contianer: Container) {
    contianer.register(MainTabBarBuildable.self) { r in
      MainTabBarBuilder(dependency: .init(
        homeBuilder: r.resolve(),
        folderBuilder: r.resolve(),
        myPageBuilder: r.resolve()
      ))
    }
  }

  private func registerHomeBuilder(container: Container) {
    container.register(HomeBuildable.self) { resolver in
      HomeBuilder(dependency: .init(
        linkBookBuilder: resolver.resolve()
      ))
    }
  }

  private func registerFolderBuilder(container: Container) {
    container.register(FolderBuildable.self) { _ in
      FolderBuilder(dependency: .init())
    }
  }

  private func registerMyPageBuilder(container: Container) {
    container.register(MyPageBuildable.self) { r in
      MyPageBuilder(dependency: .init(
        loginRepository: r.resolve(),
        tagAddBuilder: r.resolve(),
        createLinkBuilder: r.resolve()
      ))
    }.initCompleted { r, builder in
      builder.configure(loginBuilder: r.resolve())
    }
  }

  private func registerSignUpBuilder(container: Container) {
    container.register(SignUpBuildable.self) { r in
      SignUpBuilder(dependency: .init(
        loginRepository: r.resolve(),
        mainTabBuilder: r.resolve()
      ))
    }
  }

  private func registerTermsOfUseBuilder(contaier: Container) {
    contaier.register(TermsOfUseBuildable.self) { _ in
      TermsOfUseBuilder(dependency: .init())
    }
  }

  private func registerTagAddBuilder(container: Container) {
    container.register(TagAddBuildable.self) { _ in
      TagAddBuilder(dependency: .init())
    }
  }

  private func registerCreateLinkBuilder(container: Container) {
    container.register(CreateLinkBuildable.self) { r in
      CreateLinkBuilder(dependency: .init(
        selectFolderBuilder: r.resolve(),
        tagAddBuilder: r.resolve()
      ))
    }
  }

  private func registerSelectFolderBuilder(container: Container) {
    container.register(SelectFolderBuildable.self) { r in
      SelectFolderBuilder(dependency: .init())
    }
  }

  private func registerLinkBookBuilder(container: Container) {
    container.register(LinkBookBuildable.self) { _ in
      LinkBookBuilder(dependency: .init())
    }
  }
}

// MARK: - Resolver

private extension Resolver {
  func resolve<Service>() -> Service! {
    resolve(Service.self)
  }
}
