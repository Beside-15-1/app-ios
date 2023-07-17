//
//  FolderDetailViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/17.
//

import UIKit

import ReactorKit
import RxSwift

import DesignSystem

final class FolderDetailViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = FolderDetailView()


  // MARK: Properties

  var disposeBag = DisposeBag()


  // MARK: Initializing

  init(reactor: FolderDetailViewReactor) {
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

    configureNavigationBar()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.isNavigationBarHidden = false
  }


  // MARK: Binding

  func bind(reactor: FolderDetailViewReactor) {
    bindContent(with: reactor)
  }

  private func bindContent(with reactor: FolderDetailViewReactor) {
    reactor.state.map(\.folderList)
      .asObservable()
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, list in
        self.contentView.configureTabs(by: list)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.selectedFolder)
      .asObservable()
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, folder in
        let row = reactor.currentState.folderList.firstIndex(where: { $0.title == folder.title })
        self.contentView.tabViewSelectItem(at: row ?? 0)
      }
      .disposed(by: disposeBag)
  }
}


// MARK: - NavigationBar

extension FolderDetailViewController {

  private func configureNavigationBar() {
    let backButton = UIBarButtonItem(
      image: DesignSystemAsset.iconLeft.image.withTintColor(.white),
      style: .plain,
      target: self,
      action: #selector(pop)
    )

    navigationItem.leftBarButtonItem = backButton
    navigationItem.leftBarButtonItem?.tintColor = .white
    navigationItem.title = "내 폴더"

    let attributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white,
      NSAttributedString.Key.font: UIFont.defaultRegular
    ]
    navigationController?.navigationBar.titleTextAttributes = attributes
  }

  @objc
  private func pop() {
    navigationController?.popViewController(animated: true)
  }
}
