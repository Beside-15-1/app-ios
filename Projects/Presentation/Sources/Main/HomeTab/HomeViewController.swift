//
//  HomeViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/05.
//

import UIKit

import ReactorKit
import RxSwift

import PresentationInterface

final class HomeViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = HomeView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let createLinkBuilder: CreateLinkBuildable


  // MARK: Initializing

  init(
    reactor: HomeViewReactor,
    createLinkBuilder: CreateLinkBuildable
  ) {
    defer { self.reactor = reactor }
    self.createLinkBuilder = createLinkBuilder

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
    navigationController?.isNavigationBarHidden = true
  }


  // MARK: Binding

  func bind(reactor: HomeViewReactor) {
    bindButtons(with: reactor)
  }

  private func bindButtons(with reactor: HomeViewReactor) {
    contentView.fab.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        let vc = self.createLinkBuilder.build(payload: .init())
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
      }
      .disposed(by: disposeBag)
  }
}
