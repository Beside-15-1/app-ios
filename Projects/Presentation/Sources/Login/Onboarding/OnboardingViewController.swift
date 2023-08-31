//
//  OnboardingViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/07.
//

import UIKit

import ReactorKit
import RxSwift

import PresentationInterface


final class OnboardingViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = OnboardingView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let mainTabBuilder: MainTabBarBuildable

  private var transition: UIViewControllerAnimatedTransitioning?


  // MARK: Initializing

  init(
    reactor: OnboardingViewReactor,
    mainTabBuilder: MainTabBarBuildable
  ) {
    defer { self.reactor = reactor }

    self.mainTabBuilder = mainTabBuilder

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.isNavigationBarHidden = true
  }


  // MARK: Binding

  func bind(reactor: OnboardingViewReactor) {
    reactor.state.map(\.type)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, type in
        self.contentView.configure(type: type)
      }
      .disposed(by: disposeBag)

    contentView.button.rx.controlEvent(.touchUpInside)
      .map { Reactor.Action.buttonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    reactor.state.map(\.shouldRouteMain)
      .distinctUntilChanged()
      .filter { $0 }
      .subscribe(with: self) { `self`, _ in
        let mainTab = self.mainTabBuilder.build(payload: .init())
        self.transition = FadeAnimator(animationDuration: 0.5, isPresenting: true)
        let navigation = self.splitViewController?.viewController(for: .secondary) as? UINavigationController
        navigation?.setViewControllers([mainTab], animated: true)
        self.splitViewController?.changeDisplayMode(to: .oneBesideSecondary)
        self.transition = nil
      }
      .disposed(by: disposeBag)
  }
}


// MARK: UINavigationControllerDelegate

extension OnboardingViewController: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController,
    to toVC: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    transition
  }
}
