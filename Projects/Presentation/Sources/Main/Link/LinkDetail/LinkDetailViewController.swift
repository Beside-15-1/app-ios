//
//  LinkDetailViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/18.
//

import UIKit

import ReactorKit
import RxSwift

import DesignSystem


final class LinkDetailViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = LinkDetailView()


  // MARK: Properties

  var disposeBag = DisposeBag()


  // MARK: Initializing

  init(reactor: LinkDetailViewReactor) {
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

  func bind(reactor: LinkDetailViewReactor) {}
}


// MARK: - NavigationBar

extension LinkDetailViewController {

  private func configureNavigationBar() {
    let backButton = UIBarButtonItem(
      image: DesignSystemAsset.iconLeft.image.withTintColor(.staticBlack),
      style: .plain,
      target: self,
      action: #selector(pop)
    )

    let shareButton = UIBarButtonItem(
      image: DesignSystemAsset.iconShareOutline.image.withTintColor(.staticBlack),
      style: .plain,
      target: self,
      action: #selector(share)
    )

    navigationItem.leftBarButtonItem = backButton
    navigationItem.leftBarButtonItem?.tintColor = .staticBlack
    navigationItem.rightBarButtonItem = shareButton
    navigationItem.rightBarButtonItem?.tintColor = .staticBlack
    navigationItem.title = "링크 상세정보"

    let attributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white,
      NSAttributedString.Key.font: UIFont.defaultRegular,
    ]
    navigationController?.navigationBar.titleTextAttributes = attributes
  }

  @objc
  private func pop() {
    navigationController?.popViewController(animated: true)
  }

  @objc
  private func share() {

  }
}
