//
//  MasterViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/28.
//

import UIKit

import ReactorKit
import RxSwift

import PresentationInterface

final class MasterViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = MasterView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  weak var delegate: MasterDelegate?


  // MARK: Initializing

  init(reactor: MasterViewReactor) {
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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.isNavigationBarHidden = true
  }


  // MARK: Binding

  func bind(reactor: MasterViewReactor) {
    bindButtons(with: reactor)
  }

  private func bindButtons(with reactor: MasterViewReactor) {
    contentView.masterDetailButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.splitViewController?.changeDisplayMode(to: .secondaryOnly)
      }
      .disposed(by: disposeBag)

    contentView.homeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.delegate?.masterHomeTapped()
      }
      .disposed(by: disposeBag)

    contentView.folderButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.delegate?.masterFolderTapped()
      }
      .disposed(by: disposeBag)

    contentView.myPageButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.delegate?.masterMyPageTapped()
      }
      .disposed(by: disposeBag)
  }
}