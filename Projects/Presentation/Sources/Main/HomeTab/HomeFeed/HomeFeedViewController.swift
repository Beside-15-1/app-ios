//
//  HomeFeedViewController.swift
//  Presentation
//
//  Created by 박천송 on 6/21/24.
//

import UIKit

import ReactorKit
import RxSwift


final class HomeFeedViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = HomeFeedView()


  // MARK: Properties

  var disposeBag = DisposeBag()


  // MARK: Initializing

  init(reactor: HomeFeedViewReactor) {
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
  }


  // MARK: Binding

  func bind(reactor: HomeFeedViewReactor) {}
}
