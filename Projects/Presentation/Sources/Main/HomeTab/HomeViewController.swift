//
//  HomeViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/05.
//

import UIKit

import ReactorKit
import RxSwift
import Toaster

import DesignSystem
import Domain
import PBAnalyticsInterface
import PBLog
import PresentationInterface

final class HomeViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = HomeView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let analytics: PBAnalytics
  private let createLinkBuilder: CreateLinkBuildable
  private let createFolderBuilder: CreateFolderBuildable
  private let folderDetailBuilder: FolderDetailBuildable
  private let webBuilder: PBWebBuildable

  // MARK: Initializing

  init(
    reactor: HomeViewReactor,
    analytics: PBAnalytics,
    createLinkBuilder: CreateLinkBuildable,
    createFolderBuilder: CreateFolderBuildable,
    folderDetailBuilder: FolderDetailBuildable,
    webBuilder: PBWebBuildable
  ) {
    defer { self.reactor = reactor }
    self.analytics = analytics
    self.createLinkBuilder = createLinkBuilder
    self.createFolderBuilder = createFolderBuilder
    self.folderDetailBuilder = folderDetailBuilder
    self.webBuilder = webBuilder
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView

    contentView.homeFolderView.delegate = self
    contentView.homeLinkView.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    reactor?.action.onNext(.viewDidLoad)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reactor?.action.onNext(.viewWillAppear)
    navigationController?.isNavigationBarHidden = true
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    analytics.log(type: HomeEvent.shown)
  }


  // MARK: Binding

  func bind(reactor: HomeViewReactor) {
    bindButtons(with: reactor)
    bindContent(with: reactor)
  }

  private func bindButtons(with reactor: HomeViewReactor) {
    contentView.fab.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in

        self.analytics.log(type: HomeEvent.click(component: .floatingAddLink))

        let vc = self.createLinkBuilder.build(payload: .init(
          delegate: self,
          link: nil,
          folder: nil
        ))

        self.presentPaperSheet(vc)
      }
      .disposed(by: disposeBag)

    contentView.homeLinkView.newLinkButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in

        self.analytics.log(type: HomeEvent.click(component: .cardAddLink))

        let vc = self.createLinkBuilder.build(payload: .init(
          delegate: self,
          link: nil,
          folder: nil
        ))

        self.presentPaperSheet(vc)
      }
      .disposed(by: disposeBag)

    contentView.homeFolderView.moveToFolderButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.tabBarController?.selectedIndex = 1
      }
      .disposed(by: disposeBag)

    contentView.viewAllButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in

        self.analytics.log(type: HomeEvent.click(component: .myFolder))

        var folderList = reactor.currentState.folderList
        folderList.insert(.all(), at: 0)

        let folderDetail = self.folderDetailBuilder.build(
          payload: .init(
            folderList: folderList,
            selectedFolder: .all()
          )
        )
        self.navigationController?.pushViewController(
          folderDetail, animated: true
        )
      }
      .disposed(by: disposeBag)

    contentView.navigationBar.masterDetailButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.splitViewController?.changeDisplayMode(to: .oneBesideSecondary)
        self.contentView.navigationBar.masterDetailButton.isHidden = true
      }
      .disposed(by: disposeBag)
  }

  private func bindContent(with reactor: HomeViewReactor) {
    reactor.state.compactMap(\.folderViewModel)
      .distinctUntilChanged()
      .asObservable()
      .subscribe(with: self) { `self`, viewModel in
        self.contentView.homeFolderView.applyCollectionViewDataSource(by: viewModel)
      }
      .disposed(by: disposeBag)

    reactor.state.compactMap(\.linkViewModel)
      .distinctUntilChanged()
      .asObservable()
      .subscribe(with: self) { `self`, viewModel in
        self.contentView.applyCollectionViewDataSource(by: viewModel)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.linkList)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, list in
        let unreadCount = list.filter { $0.readCount == 0 }.count
        self.contentView.configureTitleWithUnreadLinkCount(linkCount: list.count, unreadLinkCount: unreadCount)
      }
      .disposed(by: disposeBag)
  }


  // MARK: Configuring

  func configureMasterDetail(displayMode: UISplitViewController.DisplayMode) {
    guard displayMode == .secondaryOnly else { return }
    contentView.navigationBar.masterDetailButton.isHidden = false
  }
}


// MARK: HomeFolderViewDelegate

extension HomeViewController: HomeFolderViewDelegate {
  func createFolderDidTapped() {
    analytics.log(type: HomeEvent.click(component: .addFolder))

    let vc = createFolderBuilder.build(
      payload: .init(
        folder: nil,
        delegate: self
      )
    )

    presentPaperSheet(vc)
  }

  func homeFolderView(didSelectItemAt row: Int) {
    // 라우팅
    guard let folderList = reactor?.currentState.folderList
    else { return }

    analytics.log(type: HomeEvent.click(component: .folder))

    var newFolderList = folderList
    newFolderList.insert(.all(), at: 0)

    let folderDetail = folderDetailBuilder.build(
      payload: .init(
        folderList: newFolderList,
        selectedFolder: folderList[row]
      )
    )

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.tabBarController?.selectedViewController?
        .navigationController?.pushViewController(
          folderDetail, animated: true
        )
    }
  }
}


// MARK: CreateFolderDelegate

extension HomeViewController: CreateFolderDelegate {
  func createFolderSucceed(folder: Folder) {
    reactor?.action.onNext(.createFolderSucceed)
  }
}


extension HomeViewController: CreateLinkDelegate {
  func createLinkSucceed(link: Link) {
    reactor?.action.onNext(.refresh)

    PBToast(content: "링크가 저장되었습니다")
      .show()
  }
}


extension HomeViewController: HomeLinkViewDelegate {
  func homeLinkView(_ homeLinkView: HomeLinkView, didSelectItemAt row: Int) {
    guard let reactor else { return }
    guard row < reactor.currentState.linkList.count else {

      if reactor.currentState.linkList[row - 1].readCount == 0 {
        analytics.log(type: HomeEvent.click(component: .moreUnreadLink))
      } else {
        analytics.log(type: HomeEvent.click(component: .moreSavedLink))
      }

      let folderDetail = folderDetailBuilder.build(
        payload: .init(
          folderList: reactor.currentState.folderList,
          selectedFolder: .all()
        )
      )

      tabBarController?.selectedViewController?
        .navigationController?.pushViewController(
          folderDetail, animated: true
        )
      return
    }

    if reactor.currentState.linkList[row].readCount == 0 {
      analytics.log(type: HomeEvent.click(component: .listUnreadLink))
    } else {
      analytics.log(type: HomeEvent.click(component: .listSavedLink))
    }

    guard let url = URL(string: reactor.currentState.linkList[row].url) else {
      return
    }

    reactor.action.onNext(.readLink(reactor.currentState.linkList[row].id))

    let options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:]

    UIApplication.shared.open(url, options: options)
  }
}
