//
//  SplitViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/24.
//

import UIKit

import ReactorKit
import RxSwift

import PresentationInterface

final class SplitViewController: UISplitViewController {

  // MARK: UI

  private lazy var contentView = SplitView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private var viewController: UIViewController?


  // MARK: Initializing

  init(
    viewController: UIViewController?
  ) {
    super.init(style: .doubleColumn)
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
}
