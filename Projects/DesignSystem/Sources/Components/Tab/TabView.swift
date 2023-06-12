//
//  TabView.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/06/12.
//

import Foundation
import UIKit

import SnapKit
import Then

enum TabSection: Hashable {
  case normal
}

public final class TabView: UIView {

  // MARK: UI

  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.register(TabCell.self, forCellWithReuseIdentifier: TabCell.identifier)
  }


  // MARK: Properties

  private var tabs: [String] = []

  private lazy var diffableDataSource = self.collectionViewDataSource()


  // MARK: Initialize

  public convenience init(tabs: [String]) {
    self.init(frame: .zero)
    applyTabs(by: tabs)
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: CollectionView

  public func applyTabs(by tabs: [String]) {
    self.tabs = tabs
    var snapshot = NSDiffableDataSourceSnapshot<TabSection, String>()

    snapshot.appendSections([.normal])
    snapshot.appendItems(tabs, toSection: .normal)

    diffableDataSource.apply(snapshot)
  }

  private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .estimated(68.0),
        heightDimension: .fractionalHeight(1.0)
      )
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .estimated(68.0),
      heightDimension: .fractionalHeight(1.0)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )

    let section = NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 8.0
    }

    let configuration = UICollectionViewCompositionalLayoutConfiguration().then {
      $0.scrollDirection = .horizontal
    }

    return UICollectionViewCompositionalLayout(section: section).then {
      $0.configuration = configuration
    }
  }

  private func collectionViewDataSource() -> UICollectionViewDiffableDataSource<TabSection, String> {
    let dataSource = UICollectionViewDiffableDataSource<TabSection, String>(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      collectionView.dequeueReusableCell(
        withReuseIdentifier: TabCell.identifier, for: indexPath
      ).then {
        guard let cell = $0 as? TabCell else { return }
        cell.configureTitle(title: item, row: indexPath.row)
      }
    }

    return dataSource
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(collectionView)

    collectionView.snp.makeConstraints {
      $0.height.equalTo(40.0)
      $0.left.right.equalToSuperview()
      $0.top.bottom.equalToSuperview().inset(8.0)
    }
  }
}
