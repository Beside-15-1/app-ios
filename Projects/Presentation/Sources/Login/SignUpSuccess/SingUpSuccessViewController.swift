//
//  SingUpSuccessViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/25.
//

import UIKit

import ReactorKit
import RxSwift
import PanModal

import PresentationInterface

final class SingUpSuccessViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = SingUpSuccessView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  weak var delegate: SignUpSuccessDelegate?


  // MARK: Initializing

  init(reactor: SingUpSuccessViewReactor) {
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

  func bind(reactor: SingUpSuccessViewReactor) {
    contentView.startButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true) {
          self.delegate?.startJoosumButtonTapped()
        }
      }
      .disposed(by: disposeBag)
  }
}


// MARK: PanModalPresentable

extension SingUpSuccessViewController: PanModalPresentable {
  var panScrollable: UIScrollView? {
    nil
  }

  var shortFormHeight: PanModalHeight {
    .contentHeight(320)
  }

  var longFormHeight: PanModalHeight {
    .contentHeight(320)
  }

  var cornerRadius: CGFloat {
    16.0
  }

  var panModalBackgroundColor: UIColor {
    .modalBackgorund
  }

  var showDragIndicator: Bool {
    true
  }
}
