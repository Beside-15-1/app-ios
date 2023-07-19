//
//  LinkDetailTagView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/19.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

class LinkDetailTagView: UIView {

  // MARK: UI

  let titleLabel = UILabel().then {
    $0.attributedText = "태그".styled(font: .defaultSemiBold, color: .gray900)
  }

  lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.register(LinkDetailTagCell.self, forCellWithReuseIdentifier: LinkDetailTagCell.identifier)
    $0.bounces = false
  }

  // MARK: Propeties

  private lazy var diffableDataSource = self.collectionViewDataSource()

  weak var delegate: AddedTagViewDelegate?

  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: CollectionView

  func applyTag(by tags: [String]) {
    var snapshot = NSDiffableDataSourceSnapshot<AddedTagSection, AddedTagItem>()

    let items = tags.map { AddedTagItem(tag: "#\($0)", row: tags.firstIndex(of: $0) ?? 0) }

    snapshot.appendSections([.normal])
    snapshot.appendItems(items, toSection: .normal)

    diffableDataSource.apply(snapshot)
  }

  private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(layoutSize: .init(
      widthDimension: .estimated(45.0),
      heightDimension: .absolute(28.0)
    ))

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(28.0)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    ).then {
      $0.interItemSpacing = .fixed(8.0)
    }

    let section = NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 8.0
    }

    return UICollectionViewCompositionalLayout(section: section).then {
      $0.configuration.scrollDirection = .horizontal
    }
  }

  private func collectionViewDataSource() -> UICollectionViewDiffableDataSource<AddedTagSection, AddedTagItem> {
    let dataSource = UICollectionViewDiffableDataSource<AddedTagSection, AddedTagItem>(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      collectionView.dequeueReusableCell(
        withReuseIdentifier: LinkDetailTagCell.identifier, for: indexPath
      ).then {
        guard let cell = $0 as? LinkDetailTagCell else { return }
        cell.configureText(text: item.tag)
      }
    }

    return dataSource
  }

  // MARK: Layout

  private func defineLayout() {
    addSubview(titleLabel)
    addSubview(collectionView)

    titleLabel.snp.makeConstraints {
      $0.left.top.equalToSuperview()
    }

    collectionView.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
    }
  }
}

// MARK: - AddedTagSection

enum LinkDetailTagSection {
  case normal
}

// MARK: - AddedTagItem

struct LinkDetailTagItem: Hashable {
  let tag: String
  let row: Int
}
