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

  typealias Section = HomeFeedSection
  typealias SectionItem = HomeFeedSectionItem
  private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, SectionItem>
  private typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>


  // MARK: UI

  lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.collectionViewLayout()
  ).then {
    $0.register(HomeFeedCell.self, forCellWithReuseIdentifier: HomeFeedCell.identifier)
    $0.register(HomeFeedMoreCell.self, forCellWithReuseIdentifier: HomeFeedMoreCell.identifier)
    $0.backgroundColor = .gray300
    $0.showsVerticalScrollIndicator = false
    $0.delegate = self
    $0.contentInset = .init(top: 0, left: 0, bottom: 60.0, right: 0)
  }


  // MARK: Properties

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

  func applyCollectionViewDataSource(
    by sectionViewModels: [HomeFeedSectionViewModel]
  ) {
    var snapshot = DiffableSnapshot()
    snapshot.appendSections(sectionViewModels.map { $0.section })
    sectionViewModels.forEach {
      snapshot.appendItems($0.items, toSection: $0.section)
    }

    diffableDataSource.apply(snapshot)
  }

  private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
      switch sectionIndex {
      case 0:
        // 첫 번째 섹션
        let totalWidth = UIScreen.main.bounds.width
        let itemWidth = totalWidth - 40
        let itemHeight = itemWidth * 162 / 335 + 114

        let item = NSCollectionLayoutItem(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(itemHeight)
          )
        )

        let groupSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .estimated(itemHeight)
        )

        let group = NSCollectionLayoutGroup.vertical(
          layoutSize: groupSize,
          subitem: item,
          count: 1
        )

        return NSCollectionLayoutSection(group: group).then {
          $0.interGroupSpacing = 20.0
        }

      case 1:
        // 첫 번째 섹션
        let item = NSCollectionLayoutItem(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(48)
          )
        )

        let groupSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .estimated(48)
        )

        let group = NSCollectionLayoutGroup.vertical(
          layoutSize: groupSize,
          subitem: item,
          count: 1
        )

        return NSCollectionLayoutSection(group: group).then {
          $0.interGroupSpacing = 20.0
        }

      default:
        return nil
      }
    }

    return layout.then {
      $0.configuration = UICollectionViewCompositionalLayoutConfiguration().then {
        $0.scrollDirection = .vertical
        $0.interSectionSpacing = 20.0
      }
    }
  }

  private func collectionViewDiffableDataSource() -> DiffableDataSource {
    UICollectionViewDiffableDataSource<Section, SectionItem>(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      switch item {
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
