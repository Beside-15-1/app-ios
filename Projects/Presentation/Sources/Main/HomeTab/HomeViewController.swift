//
//  HomeViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/05.
//

import UIKit

import ReactorKit
import RxSwift


final class HomeViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = HomeView()


  // MARK: Properties

  var disposeBag = DisposeBag()


  // MARK: Initializing

  init(reactor: HomeViewReactor) {
    defer { self.reactor = reactor }
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

  func bind(reactor: HomeViewReactor) {}
}
