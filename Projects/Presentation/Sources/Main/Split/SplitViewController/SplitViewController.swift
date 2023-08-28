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


  // MARK: Properties

  var disposeBag = DisposeBag()

  private var masterViewController: UIViewController?
  private var detailViewController: UIViewController?


  // MARK: Initializing

  override init(style: UISplitViewController.Style) {
    super.init(style: style)
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
  }
}


extension SplitViewController: UISplitViewControllerDelegate {

}
