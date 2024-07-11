//
//  HomeFeedView.swift
//  Presentation
//
//  Created by 박천송 on 6/21/24.
//

import UIKit

import SnapKit
import Then

import DesignSystem

protocol HomeFeedViewDelegate: AnyObject {
  func homeFeedTabViewRecentlySavedButtonTapped()
  func homeFeedTabViewNoReadButtonTapped()
  func homeFeedListViewDidSelectBanner()
  func homeFeedListViewDidSelectLink(id: String, url: String?)
  func homeFeedListViewDidSelectMore()
  func homeFeedFABButtonTapped()
  func pullToRefresh()
}

final class HomeFeedView: UIView {

  // MARK: UI

  private let listView = HomeFeedListView()

  private let colorBackground = UIView().then {
    $0.backgroundColor = .paperAboveBg
  }

  let navigationBar = MainNavigationBar(style: .home)

  private let tabView = HomeFeedTabView()

  private let fab = FAB()


  // MARK: Properties

  weak var delegate: HomeFeedViewDelegate?


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()

    tabView.delegate = self
    listView.delegate = self

    fab.addAction(UIAction(handler: { [weak self] _ in
      self?.delegate?.homeFeedFABButtonTapped()
    }), for: .touchUpInside)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configureDataSource(
    by sectionViewModels: [SectionViewModel<HomeFeedModel.Section, HomeFeedModel.Item>]
  ) {
    listView.update(sections: sectionViewModels)
  }

  func configureTab(tab: HomeFeedTab) {
    tabView.configureTab(tab: tab)
    listView.configureEmptyView(tab: tab)
  }

  func endRefreshing() {
    listView.endRefreshing()
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(colorBackground)
    addSubview(navigationBar)
    addSubview(listView)
    addSubview(tabView)
    addSubview(fab)

    navigationBar.snp.makeConstraints {
      $0.left.right.top.equalTo(safeAreaLayoutGuide)
    }

    colorBackground.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.bottom.equalTo(navigationBar.snp.top)
    }

    tabView.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(navigationBar.snp.bottom)
      $0.height.equalTo(52)
    }

    listView.snp.makeConstraints {
      $0.top.equalTo(tabView.snp.bottom)
      $0.bottom.left.right.equalToSuperview()
    }

    fab.snp.makeConstraints {
      $0.right.equalToSuperview().inset(20.0)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(12.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}


// MARK: HomeFeedTabViewDelegate

extension HomeFeedView: HomeFeedTabViewDelegate {
  func homeFeedTabViewNoReadButtonTapped() {
    delegate?.homeFeedTabViewNoReadButtonTapped()
  }

  func homeFeedTabViewRecentlySavedButtonTapped() {
    delegate?.homeFeedTabViewRecentlySavedButtonTapped()
  }
}


// MARK: HomeFeedListViewDelegate

extension HomeFeedView: HomeFeedListViewDelegate {
  func didSelectBanner(_ listView: HomeFeedListView) {
    delegate?.homeFeedListViewDidSelectBanner()
  }

  func didSelectMoreButton(_ listView: HomeFeedListView) {
    delegate?.homeFeedListViewDidSelectMore()
  }

  func didSelectLink(_ listView: HomeFeedListView, id: String, url: String?) {
    delegate?.homeFeedListViewDidSelectLink(id: id, url: url)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y > 50 {
      fab.contract()
    } else {
      fab.expand()
    }
  }

  func pullToRefresh() {
    delegate?.pullToRefresh()
  }
}
