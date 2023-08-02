//
//  TabView.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/06/12.
//

import Foundation
import UIKit

import RxRelay
import RxSwift
import SnapKit
import Then

enum PrimaryTabSection: Hashable {
  case normal
}

public struct PrimaryTab: Hashable {
  public let title: String
  public let id: UUID

  public init(title: String, id: UUID) {
    self.title = title
    self.id = id
  }
}

public protocol TabViewDelegate: AnyObject {
  func tabView(didSelectedTab: String)
}

public final class PrimaryTabView: UIView {

  // MARK: UI

  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.register(PrimaryTabCell.self, forCellWithReuseIdentifier: PrimaryTabCell.identifier)
    $0.delegate = self
    $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
  }


  // MARK: Properties

  private var tabs: [String] = []

  private lazy var diffableDataSource = self.collectionViewDataSource()

  public weak var delegate: TabViewDelegate?
  public var selectedTab: PublishRelay<String> = .init()


  // MARK: Initialize

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
    var snapshot = NSDiffableDataSourceSnapshot<PrimaryTabSection, PrimaryTab>()

    snapshot.appendSections([.normal])
    snapshot.appendItems(tabs.map { PrimaryTab(title: $0, id: UUID()) }, toSection: .normal)

    diffableDataSource.apply(snapshot)
  }

  public func selectItem(at row: Int) {
    DispatchQueue.main.async {
      self.collectionView.selectItem(
        at: IndexPath(item: row, section: 0),
        animated: false,
        scrollPosition: .centeredHorizontally
      )
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      guard let cell = self.collectionView.cellForItem(at: IndexPath(item: row, section: 0))
              as? PrimaryTabCell else { return }

      cell.configure(isSelected: true)
    }
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

  private func collectionViewDataSource() -> UICollectionViewDiffableDataSource<PrimaryTabSection, PrimaryTab> {
    let dataSource = UICollectionViewDiffableDataSource<PrimaryTabSection, PrimaryTab>(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      collectionView.dequeueReusableCell(
        withReuseIdentifier: PrimaryTabCell.identifier, for: indexPath
      ).then { cell in
        guard let cell = cell as? PrimaryTabCell else { return }
        cell.configure(title: item.title)
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


extension PrimaryTabView: UICollectionViewDelegate {
  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {

    delegate?.tabView(didSelectedTab: tabs[indexPath.row])
    selectedTab.accept(tabs[indexPath.row])
  }
}
