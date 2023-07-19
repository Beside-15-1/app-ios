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
import PresentationInterface

final class FolderDetailViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = FolderDetailView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let linkSortBuilder: LinkSortBuildable
  private let linkDetailBuilder: LinkDetailBuildable


  // MARK: Initializing

  init(
    reactor: FolderDetailViewReactor,
    linkSortBuilder: LinkSortBuildable,
    linkDetailBuilder: LinkDetailBuildable
  ) {
    defer { self.reactor = reactor }

    self.linkSortBuilder = linkSortBuilder
    self.linkDetailBuilder = linkDetailBuilder

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

    reactor?.action.onNext(.viewDidLoad)

    configureNavigationBar()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.isNavigationBarHidden = false
  }


  // MARK: Binding

  func bind(reactor: FolderDetailViewReactor) {
    bindContent(with: reactor)
    bindTab(with: reactor)
    bindRoute(with: reactor)
    bindTextField(with: reactor)
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
  }

  private func bindTab(with reactor: FolderDetailViewReactor) {
    contentView.tabView.selectedTab
      .asObservable()
      .map { Reactor.Action.selectTab($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindRoute(with reactor: FolderDetailViewReactor) {
    contentView.listView.sortButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let vc = self.linkSortBuilder.build(
          payload: .init(
            delegate: self,
            sortType: reactor.currentState.sortingType
          )
        ) as? PanModalPresentable.LayoutType else { return }

        self.presentPanModal(vc)
      }
      .disposed(by: disposeBag)
  }

  private func bindTextField(with reactor: FolderDetailViewReactor) {
    contentView.searchField.rx.text
      .subscribe(with: self) { `self`, text in
        reactor.action.onNext(.searchLink(text))
        self.contentView.listView.configureEmptyLabel(text: text)
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
      NSAttributedString.Key.font: UIFont.defaultRegular,
    ]
    navigationController?.navigationBar.titleTextAttributes = attributes
  }

  @objc
  private func pop() {
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
    guard let reactor else { return }

    let linkDetail = linkDetailBuilder.build(payload: .init(link: reactor.currentState.linkList[row]))

    self.navigationController?.pushViewController(linkDetail, animated: true)
  }

  func listViewMoreButtonTapped(id: String) {

  }
}
