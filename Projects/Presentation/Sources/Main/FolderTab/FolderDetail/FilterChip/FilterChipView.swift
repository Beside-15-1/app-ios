//
//  FilterChipView.swift
//  DesignSystem
//
//  Created by 박천송 on 2/22/24.
//  Copyright © 2024 PinkBoss Inc. All rights reserved.
//

import Foundation
import UIKit

import SnapKit
import Then

enum FilterChipListSection: Hashable {
  case items
}

extension FilterChipListSection {
  enum Item: Hashable {
    case normal(FilterChipCell.ViewModel)
  }
}

protocol FilterChipViewDelegate: AnyObject {
  func filterChipTapped()
}

class FilterChipView: UIView {

  typealias Section = FilterChipListSection
  typealias SectionItem = FilterChipListSection.Item
  private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, SectionItem>
  private typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>

  // MARK: UI

  lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.delegate = self
    $0.register(FilterChipCell.self, forCellWithReuseIdentifier: FilterChipCell.identifier)
    $0.bounces = false
  }

  // MARK: Propeties

  private lazy var diffableDataSource = self.collectionViewDataSource()

  weak var delegate: FilterChipViewDelegate?

  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: CollectionView

  func applyChips(by items: [SectionItem]) {
    var snapshot = DiffableSnapshot()

    snapshot.appendSections([.items])
    snapshot.appendItems(items, toSection: .items)

    diffableDataSource.apply(snapshot)
  }

  private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(layoutSize: .init(
      widthDimension: .estimated(45.0),
      heightDimension: .absolute(28.0)
    ))

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .estimated(45.0),
      heightDimension: .absolute(28.0)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    ).then {
      $0.interItemSpacing = .fixed(4.0)
    }

    let section = NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 4.0
      $0.orthogonalScrollingBehavior = .continuous
    }

    return UICollectionViewCompositionalLayout(section: section).then {
      $0.configuration.scrollDirection = .horizontal
    }
  }

  private func collectionViewDataSource() -> DiffableDataSource {
    let dataSource = UICollectionViewDiffableDataSource<Section, SectionItem>(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      collectionView.dequeueReusableCell(
        withReuseIdentifier: FilterChipCell.identifier, for: indexPath
      ).then {
        guard let cell = $0 as? FilterChipCell else { return }
        switch item {
        case .normal(let viewModel):
          cell.configure(viewModel: viewModel)
        }
      }
    }

    return dataSource
  }

  // MARK: Layout

  private func defineLayout() {
    addSubview(collectionView)

    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(28.0)
    }
  }
}


// MARK: CollectionView

extension FilterChipView: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.filterChipTapped()
  }
}
