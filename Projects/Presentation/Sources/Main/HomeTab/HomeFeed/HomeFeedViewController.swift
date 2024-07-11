//
//  HomeFeedViewController.swift
//  Presentation
//
//  Created by 박천송 on 6/21/24.
//

import UIKit

import ReactorKit
import RxSwift

import DesignSystem
import PresentationInterface


final class HomeFeedViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = HomeFeedView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let folderDetailBuilder: FolderDetailBuildable


  // MARK: Initializing

  init(
    reactor: HomeFeedViewReactor,
    folderDetailBuilder: FolderDetailBuildable
  ) {
    defer { self.reactor = reactor }
    self.folderDetailBuilder = folderDetailBuilder
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView

    contentView.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    reactor?.action.onNext(.viewDidLoad)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }


  // MARK: Binding

  func bind(reactor: HomeFeedViewReactor) {
    bindContent(with: reactor)
  }

  private func bindContent(with reactor: HomeFeedViewReactor) {
    reactor.state.map(\.tab)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, tab in
        self.contentView.configureTab(tab: tab)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.sectionViewModels)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, sectionViewModels in
        self.contentView.configureDataSource(by: sectionViewModels)
      }
      .disposed(by: disposeBag)
  }
}


// MARK: HomeFeedViewDelegate

extension HomeFeedViewController: HomeFeedViewDelegate {
  func homeFeedTabViewNoReadButtonTapped() {
    reactor?.action.onNext(.noReadButtonTapped)
  }

  func homeFeedTabViewRecentlySavedButtonTapped() {
    reactor?.action.onNext(.recentlySavedButtonTapped)
  }

  func homeFeedListViewDidSelectBanner() {}

  func homeFeedListViewDidSelectLink(id: String, url: String?) {
    guard let url = URL(string: url ?? "") else {
      return
    }

    let options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:]

    UIApplication.shared.open(url, options: options)

    reactor?.action.onNext(.readLink(id))
  }

  func homeFeedListViewDidSelectMore() {
    let folderDetail = folderDetailBuilder.build(
      payload: .init(
        folderList: [],
        selectedFolder: .all()
      )
    )

    tabBarController?.selectedViewController?
      .navigationController?.pushViewController(
        folderDetail, animated: true
      )
  }
}
