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
      registerCreateFolderBuilder,
      registerHomeBuilder,
      registerFolderBuilder,
      registerMyPageBuilder,
      registerSignUpBuilder,
      registerTermsOfUseBuilder,
      registerTagAddBuilder,
      registerCreateLinkBuilder,
      registerSelectFolderBuilder,
      registerSignUpBuilder,
      registerEditFolderBuilder,
      registerFolderSortBuilder,
      registerFolderDetailBuilder,
      registerLinkSortBuilder,
      registerLinkDetailBuilder,
      registerMoveFolderBuilder,
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
        myFolderBuilder: r.resolve(),
        myPageBuilder: r.resolve()
      ))
    }
  }

  private func registerHomeBuilder(container: Container) {
    container.register(HomeBuildable.self) { r in
      HomeBuilder(dependency: .init(
        folderRepository: r.resolve(),
        linkRepository: r.resolve(),
        createLinkBuilder: r.resolve(),
        createFolderBuilder: r.resolve(),
        folderDetailBuilder: r.resolve()
      ))
    }
  }

  private func registerFolderBuilder(container: Container) {
    container.register(MyFolderBuildable.self) { r in
      MyFolderBuilder(dependency: .init(
        folderRepository: r.resolve(),
        createFolderBuilder: r.resolve(),
        editFolderBuilder: r.resolve(),
        folderSortBuilder: r.resolve(),
        folderDetailBuilder: r.resolve()
      ))
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
        folderRepository: r.resolve(),
        linkRepository: r.resolve(),
        selectFolderBuilder: r.resolve(),
        tagAddBuilder: r.resolve(),
        createFolderBuilder: r.resolve()
      ))
    }
  }

  private func registerSelectFolderBuilder(container: Container) {
    container.register(SelectFolderBuildable.self) { r in
      SelectFolderBuilder(dependency: .init())
    }
  }

  private func registerCreateFolderBuilder(container: Container) {
    container.register(CreateFolderBuildable.self) { r in
      CreateFolderBuilder(dependency: .init(
        folderRepository: r.resolve()
      ))
    }
  }

  private func registerEditFolderBuilder(container: Container) {
    container.register(EditFolderBuildable.self) { r in
      EditFolderBuilder(dependency: .init(
        createFolderBuilder: r.resolve()
      ))
    }
  }

  private func registerFolderSortBuilder(container: Container) {
    container.register(FolderSortBuildable.self) { r in
      FolderSortBuilder(dependency: .init())
    }
  }

  private func registerFolderDetailBuilder(container: Container) {
    container.register(FolderDetailBuildable.self) { r in
      FolderDetailBuilder(dependency: .init(
        linkRepository: r.resolve(),
        linkSortBuilder: r.resolve(),
        linkDetailBuilder: r.resolve()
      ))
    }
  }

  private func registerLinkSortBuilder(container: Container) {
    container.register(LinkSortBuildable.self) { r in
      LinkSortBuilder(dependency: .init())
    }
  }

  private func registerLinkDetailBuilder(container: Container) {
    container.register(LinkDetailBuildable.self) { r in
      LinkDetailBuilder(dependency: .init(
        linkRepository: r.resolve(),
        createLinkBuilder: r.resolve(),
        moveFolderBuilder: r.resolve()
      ))
    }
  }

  private func registerMoveFolderBuilder(container: Container) {
    container.register(MoveFolderBuildable.self) { r in
      MoveFolderBuilder(dependency: .init(
        folderRepository: r.resolve()
      ))
    }
  }
}

// MARK: - Resolver

extension Resolver {
  fileprivate func resolve<Service>() -> Service! {
    resolve(Service.self)
  }
}
