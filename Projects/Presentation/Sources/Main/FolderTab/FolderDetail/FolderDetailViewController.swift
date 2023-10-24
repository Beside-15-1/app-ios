//
//  FolderDetailViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/17.
//

import UIKit

import PanModal
import ReactorKit
import RxSwift

import DesignSystem
import Domain
import PBAnalyticsInterface
import PresentationInterface

final class FolderDetailViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = FolderDetailView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let analytics: PBAnalytics
  private let linkSortBuilder: LinkSortBuildable
  private let linkDetailBuilder: LinkDetailBuildable
  private let createLinkBuilder: CreateLinkBuildable


  // MARK: Initializing

  init(
    reactor: FolderDetailViewReactor,
    analytics: PBAnalytics,
    linkSortBuilder: LinkSortBuildable,
    linkDetailBuilder: LinkDetailBuildable,
    createLinkBuilder: CreateLinkBuildable
  ) {
    defer { self.reactor = reactor }

    self.analytics = analytics
    self.linkSortBuilder = linkSortBuilder
    self.linkDetailBuilder = linkDetailBuilder
    self.createLinkBuilder = createLinkBuilder

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView

    contentView.listView.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.interactivePopGestureRecognizer?.delegate = nil

    reactor?.action.onNext(.viewDidLoad)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.isNavigationBarHidden = false

    configureNavigationBar()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    analytics.log(type: LinkListEvent.shown)
  }


  // MARK: Binding

  func bind(reactor: FolderDetailViewReactor) {
    bindContent(with: reactor)
    bindTab(with: reactor)
    bindRoute(with: reactor)
    bindTextField(with: reactor)
    bindButton(with: reactor)
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

    reactor.state.compactMap(\.viewModel)
      .asObservable()
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, viewModel in
        self.contentView.listView.applyCollectionViewDataSource(by: viewModel)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.sortingType)
      .asObservable()
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, type in
        self.contentView.listView.sortButton.text = type.title
      }
      .disposed(by: disposeBag)

    contentView.listView.refreshControl.rx.controlEvent(.valueChanged)
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    reactor.pulse(\.$refreshEnd)
      .asObservable()
      .subscribe(with: self) { `self`, _ in
        self.contentView.listView.refreshControl.endRefreshing()
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.linkCount)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, count in
        self.contentView.listView.configureTotalCount(count: count)
      }
      .disposed(by: disposeBag)
  }

  private func bindTab(with reactor: FolderDetailViewReactor) {
    contentView.tabView.selectedTab
      .asObservable()
      .subscribe(with: self) { `self`, tab in
        guard tab != reactor.currentState.selectedFolder.title else {
          return
        }

        self.analytics.log(type: LinkListEvent.click(component: .tabOtherFolder))

        reactor.action.onNext(.selectTab(tab))
        self.contentView.searchField.text = ""
      }
      .disposed(by: disposeBag)
  }

  private func bindRoute(with reactor: FolderDetailViewReactor) {
    contentView.listView.sortButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.analytics.log(type: LinkListEvent.click(component: .sortby))

        guard let vc = self.linkSortBuilder.build(
          payload: .init(
            delegate: self,
            sortType: reactor.currentState.sortingType
          )
        ) as? PanModalPresentable.LayoutType else { return }

        self.presentModal(
          vc,
          preferredContentSize: .init(width: 375, height: 252 - self.view.safeAreaInsets.bottom),
          arrowDirection: .up,
          sourceView: self.contentView.listView.sortButton,
          sourceRect: .init(
            origin: .init(
              x: self.contentView.listView.sortButton.frame.width / 2,
              y: self.contentView.listView.sortButton.frame.height
            ),
            size: .zero
          )
        )
      }
      .disposed(by: disposeBag)

    contentView.fab.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        let vc = self.createLinkBuilder.build(payload: .init(
          delegate: self,
          link: nil
        ))

        self.presentPaperSheet(vc)
      }
      .disposed(by: disposeBag)
  }

  private func bindTextField(with reactor: FolderDetailViewReactor) {
    contentView.searchField.rx.text
      .subscribe(with: self) { `self`, text in
        reactor.action.onNext(.searchLink(text))
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.emptyLabelText)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, viewModel in
        self.contentView.listView.configureEmptyLabel(viewModel: viewModel)
      }
      .disposed(by: disposeBag)

    contentView.searchField.rx.editingDidBegin
      .subscribe(with: self) { `self`, _ in
        self.analytics.log(type: LinkListEvent.click(component: .searchInput))
      }
      .disposed(by: disposeBag)
  }

  private func bindButton(with reactor: FolderDetailViewReactor) {
    contentView.unreadFilterButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.analytics.log(type: LinkListEvent.click(component: .filterUnread))
        reactor.action.onNext(.updateUnreadFiltering(self.contentView.unreadFilterButton.isSelected))
      }
      .disposed(by: disposeBag)
  }

  func selectTab(tab: String) {
    reactor?.action.onNext(.selectTab(tab))
  }
}


// MARK: - NavigationBar

extension FolderDetailViewController {

  private func configureNavigationBar() {
    let backButton = UIBarButtonItem(
      image: DesignSystemAsset.iconPop.image.withTintColor(.white),
      style: .plain,
      target: self,
      action: #selector(pop)
    )

    navigationItem.leftBarButtonItem = backButton
    navigationItem.leftBarButtonItem?.tintColor = .white
    navigationItem.title = "내 폴더"

    let attributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white,
      NSAttributedString.Key.font: UIFont.titleBold,
    ]
    navigationController?.navigationBar.titleTextAttributes = attributes
  }

  @objc
  private func pop() {
    analytics.log(type: LinkListEvent.click(component: .back))
    navigationController?.popViewController(animated: true)
  }
}


// MARK: LinkSortDelegate

extension FolderDetailViewController: LinkSortDelegate {
  func linkSortListItemTapped(type: LinkSortingType) {
    reactor?.action.onNext(.updateSort(type))
  }
}


extension FolderDetailViewController: FolderDetailListViewDelegate {
  func listViewItemDidTapped(at row: Int) {
    guard let reactor,
          let id = reactor.currentState.viewModel?.items[row].id,
          let link = reactor.currentState.linkList.first(where: { $0.id == id }),
          let url = URL(string: link.url) else { return }

    analytics.log(type: LinkListEvent.click(component: .link))

    reactor.action.onNext(.readLink(id))

    let options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:]
    UIApplication.shared.open(url, options: options)
  }

  func listViewMoreButtonTapped(id: String) {
    guard let reactor,
          let link = reactor.currentState.linkList.first(where: { $0.id == id }) else { return }

    analytics.log(type: LinkListEvent.click(component: .buttonKebab))

    let linkDetail = linkDetailBuilder.build(payload: .init(
      delegate: self,
      link: link
    ))

    if UIDevice.current.userInterfaceIdiom == .pad {
      presentPaperSheet(linkDetail)
    } else {
      navigationController?.pushViewController(linkDetail, animated: true)
    }
  }

  func listViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y > 50 {
      contentView.fab.contract()
    } else {
      contentView.fab.expand()
    }
  }
}


// MARK: CreateLinkDelegate

extension FolderDetailViewController: CreateLinkDelegate {
  func createLinkSucceed(link: Link) {
    reactor?.action.onNext(.createFolderSucceed)
  }
}


// MARK: LinkDetailDelegate

extension FolderDetailViewController: LinkDetailDelegate {
  func linkDetailDismissed() {
    reactor?.action.onNext(.refresh)
  }
}
