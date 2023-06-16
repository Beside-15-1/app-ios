import UIKit

import SnapKit
import Then

import DesignSystem

// MARK: - AddedTagSection

enum AddedTagSection {
  case normal
}

// MARK: - AddedTagView

class AddedTagView: UIView {
  // MARK: UI

  lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.delegate = self
    $0.register(AddedTagCell.self, forCellWithReuseIdentifier: AddedTagCell.identifier)
    $0.bounces = false
  }

  let emptyLabel = UILabel().then {
    $0.text = "아직 선택된 태그가 없어요"
    $0.textColor = .gray500
    $0.font = .bodyRegular
  }

  // MARK: Propeties

  private lazy var diffableDataSource = self.collectionViewDataSource()

  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: CollectionView

  func applyAddedTag(by tags: [String]) {
    emptyLabel.isHidden = !tags.isEmpty

    var snapshot = NSDiffableDataSourceSnapshot<AddedTagSection, String>()

    snapshot.appendSections([.normal])
    snapshot.appendItems(tags, toSection: .normal)

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
      $0.interItemSpacing = .fixed(8.0)
    }

    let section = NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 8.0
      $0.orthogonalScrollingBehavior = .continuous
    }

    return UICollectionViewCompositionalLayout(section: section).then {
      $0.configuration.scrollDirection = .horizontal
    }
  }

  private func collectionViewDataSource() -> UICollectionViewDiffableDataSource<AddedTagSection, String> {
    let dataSource = UICollectionViewDiffableDataSource<AddedTagSection, String>(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      collectionView.dequeueReusableCell(
        withReuseIdentifier: AddedTagCell.identifier, for: indexPath
      ).then {
        guard let cell = $0 as? AddedTagCell else { return }
        cell.configureText(text: item)
      }
    }

    return dataSource
  }

  // MARK: Layout

  private func defineLayout() {
    addSubview(emptyLabel)
    addSubview(collectionView)

    emptyLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(28.0)
    }
  }
}

// MARK: UICollectionViewDelegate

extension AddedTagView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}
