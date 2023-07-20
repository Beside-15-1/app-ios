//
//  MyPageViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/20.
//

import UIKit

import ReactorKit
import RxSwift

import PresentationInterface

final class MyPageViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = MyPageView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let loginBuilder: LoginBuildable


  // MARK: Initializing

  init(
    reactor: MyPageViewReactor,
    loginBuilder: LoginBuildable
  ) {
    defer { self.reactor = reactor }

    self.loginBuilder = loginBuilder

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
  }


  // MARK: Binding

  func bind(reactor: MyPageViewReactor) {}
}
