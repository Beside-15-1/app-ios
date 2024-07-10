//
//  HomeFeedListView.swift
//  Presentation
//
//  Created by 박천송 on 7/3/24.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem
import Domain
import PBLog

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
  }


  // MARK: Properties

  private let sectionProvider = HomeFeedSectionProvider()
  private lazy var diffableDataSource = self.collectionViewDiffableDataSource()


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .gray300

    defineLayout()
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
    self.sectionProvider.updateSectionViewModels(sections)
    self.diffableDataSource.apply(
      self.sectionProvider.snapshot(),
      animatingDifferences: animatingDifferences,
      completion: completion
    )
  }

  func updateSection(
    _ section: SectionViewModel<Section, Item>,
    animatingDifferences: Bool = true,
    completion: (() -> Void)? = nil
  ) {
    guard self.sectionProvider.updateSection(section) else {
      return
    }

    self.diffableDataSource.apply(
      self.sectionProvider.snapshot(),
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

      case .more:
        return collectionView.dequeueReusableCell(
          withReuseIdentifier: HomeFeedMoreCell.identifier,
          for: indexPath
        )
      }
    }
  }


  private func defineLayout() {
    addSubview(collectionView)

    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}


extension HomeFeedListView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    delegate?.listViewItemDidTapped(at: indexPath.row)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    delegate?.listViewDidScroll(scrollView)
  }
}
