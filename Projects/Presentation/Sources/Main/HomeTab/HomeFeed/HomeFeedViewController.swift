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
import Domain
import PBAnalyticsInterface
import PresentationInterface

final class HomeFeedViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = HomeFeedView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let analytics: PBAnalytics

  private let folderDetailBuilder: FolderDetailBuildable
  private let webBuilder: PBWebBuildable
  private let createLinkBuilder: CreateLinkBuildable


  // MARK: Initializing

  init(
    reactor: HomeFeedViewReactor,
    analytics: PBAnalytics,
    folderDetailBuilder: FolderDetailBuildable,
    webBuilder: PBWebBuildable,
    createLinkBuilder: CreateLinkBuildable
  ) {
    defer { self.reactor = reactor }
    self.analytics = analytics
    self.folderDetailBuilder = folderDetailBuilder
    self.webBuilder = webBuilder
    self.createLinkBuilder = createLinkBuilder
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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    reactor?.action.onNext(.viewDidAppear)
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

    reactor.pulse(\.$endRefreshing)
      .filter { $0 }
      .subscribe(with: self) { `self`, _ in
        self.contentView.endRefreshing()
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

  func homeFeedListViewDidSelectBanner() {
    let url: URL?

    switch reactor?.currentState.tab {
    case .noRead:
      analytics.log(type: HomeFeedEvent.click(component: .bannerUnread))
      url = URL(string: "https://www.notion.so/joosum/a694027a091c44dc87db37c63ae37611?pvs=4")
    case .recentlySaved:
      analytics.log(type: HomeFeedEvent.click(component: .bannerSaved))
      url = URL(string: "https://www.notion.so/joosum/45776b3736494e29b182375cbaa50056?pvs=4")
    default:
      url = URL(string: "")
    }

    guard let url else { return }
    let web = webBuilder.build(payload: .init(url: url))

    presentPaperSheet(web)
  }

  func homeFeedListViewDidSelectLink(id: String, url: String?) {
    guard let url = URL(string: url ?? "") else {
      return
    }

    let options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:]

    UIApplication.shared.open(url, options: options)

    reactor?.action.onNext(.readLink(id))
  }

  func homeFeedListViewDidSelectMore() {
    switch reactor?.currentState.tab {
    case .noRead:
      analytics.log(type: HomeFeedEvent.click(component: .moreUnreadLink))
    case .recentlySaved:
      analytics.log(type: HomeFeedEvent.click(component: .moreSavedLink))
    default:
      break
    }

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

  func homeFeedFABButtonTapped() {
    let vc = createLinkBuilder.build(payload: .init(
      delegate: self,
      link: nil,
      folder: nil
    ))

    analytics.log(type: HomeFeedEvent.click(component: .floatingAddLink))

    presentPaperSheet(vc)
  }

  func pullToRefresh() {
    reactor?.action.onNext(.refresh)
  }
}


// MARK: CreateLinkDelegate

extension HomeFeedViewController: CreateLinkDelegate {

  func createLinkSucceed(link: Link) {
    reactor?.action.onNext(.refresh)
  }
}
