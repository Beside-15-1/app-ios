//
//  HomeFeedListView.swift
//  Presentation
//
//  Created by 박천송 on 7/3/24.
//

import Foundation
import UIKit

import RxSwift
import SnapKit
import Then

import DesignSystem
import Domain
import PBLog

protocol HomeFeedListViewDelegate: AnyObject {
  func didSelectBanner(_ listView: HomeFeedListView)
  func didSelectMoreButton(_ listView: HomeFeedListView)
  func didSelectLink(_ listView: HomeFeedListView, id: String, url: String?)
  func scrollViewDidScroll(_ scrollView: UIScrollView)
  func pullToRefresh()
}

class HomeFeedListView: UIView {

  typealias Section = HomeFeedModel.Section
  typealias Item = HomeFeedModel.Item
  private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
  private typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<Section, Item>


  // MARK: UI

  lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.collectionViewLayout()
  ).then {
    $0.register(HomeBannerCell.self, forCellWithReuseIdentifier: HomeBannerCell.identifier)
    $0.register(HomeFeedCell.self, forCellWithReuseIdentifier: HomeFeedCell.identifier)
    $0.register(HomeFeedMoreCell.self, forCellWithReuseIdentifier: HomeFeedMoreCell.identifier)
    $0.backgroundColor = .gray300
    $0.showsVerticalScrollIndicator = false
    $0.delegate = self
    $0.contentInset = .init(top: 0, left: 0, bottom: 60.0, right: 0)
    $0.backgroundView = emptyView
  }

  private let emptyView = HomeFeedEmptyView()

  private let refreshControl = UIRefreshControl()


  // MARK: Properties

  private let sectionProvider = HomeFeedSectionProvider()
  private lazy var diffableDataSource = self.collectionViewDiffableDataSource()

  weak var delegate: HomeFeedListViewDelegate?

  private let disposeBag = DisposeBag()


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .gray300

    defineLayout()

    refreshControl.rx.controlEvent(.valueChanged)
      .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        self?.delegate?.pullToRefresh()
      })
      .disposed(by: disposeBag)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: CollectionView

  func update(
    sections: [SectionViewModel<Section, Item>],
    animatingDifferences: Bool = true,
    completion: (() -> Void)? = nil
  ) {
    sectionProvider.updateSectionViewModels(sections)
    diffableDataSource.apply(
      sectionProvider.snapshot(),
      animatingDifferences: animatingDifferences,
      completion: completion
    )

    collectionView.backgroundView?.isHidden = sections.count > 1
    collectionView.bounces = sections.count > 1

    emptyView.isHidden = sectionProvider.snapshot().numberOfItems <= 1 ? false : true
  }

  func updateSection(
    _ section: SectionViewModel<Section, Item>,
    animatingDifferences: Bool = true,
    completion: (() -> Void)? = nil
  ) {
    guard sectionProvider.updateSection(section) else {
      return
    }

    diffableDataSource.apply(
      sectionProvider.snapshot(),
      animatingDifferences: animatingDifferences,
      completion: completion
    )
  }

  private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    UICollectionViewCompositionalLayout(sectionProvider: sectionProvider.sectionLayout).then {
      $0.configuration = UICollectionViewCompositionalLayoutConfiguration().then {
        $0.scrollDirection = .vertical
        $0.interSectionSpacing = 20.0
      }
    }
  }

  private func collectionViewDiffableDataSource() -> DiffableDataSource {
    UICollectionViewDiffableDataSource<Section, Item>(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      switch item {
      case .banner(let viewModel):
        return collectionView.dequeueReusableCell(
          withReuseIdentifier: HomeBannerCell.identifier,
          for: indexPath
        ).then {
          guard let cell = $0 as? HomeBannerCell else { return }
          cell.configure(viewModel: viewModel)
        }

      case .link(let viewModel):
        return collectionView.dequeueReusableCell(
          withReuseIdentifier: HomeFeedCell.identifier,
          for: indexPath
        ).then {
          guard let cell = $0 as? HomeFeedCell else { return }
          cell.configure(viewModel: viewModel)
        }

      case .more(let viewModel):
        return collectionView.dequeueReusableCell(
          withReuseIdentifier: HomeFeedMoreCell.identifier,
          for: indexPath
        ).then {
          guard let cell = $0 as? HomeFeedMoreCell else { return }
          cell.configure(viewModel: viewModel)
        }
      }
    }
  }


  // MARK: Configuring

  func configureEmptyView(tab: HomeFeedTab) {
    emptyView.isHidden = true
    emptyView.configureEmptyView(tab: tab)
  }

  func endRefreshing() {
    refreshControl.endRefreshing()
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(collectionView)

    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    collectionView.addSubview(refreshControl)
  }
}


extension HomeFeedListView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let item = diffableDataSource.itemIdentifier(for: indexPath) else {
      return
    }

    switch item {
    case .banner:
      delegate?.didSelectBanner(self)
    case .link(let model):
      delegate?.didSelectLink(self, id: model.id, url: model.linkURL)
    case .more:
      delegate?.didSelectMoreButton(self)
    }
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    delegate?.scrollViewDidScroll(scrollView)
  }
}
