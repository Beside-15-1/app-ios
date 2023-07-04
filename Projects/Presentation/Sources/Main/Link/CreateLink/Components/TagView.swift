import UIKit

import SnapKit
import Then

import DesignSystem

// MARK: - TagSection

enum TagSection {
  case normal
}

// MARK: - TagViewView

final class TagView: UIView {
  // MARK: UI

  private let titleLabel = UILabel().then {
    $0.text = "태그"
    $0.textColor = .staticBlack
    $0.font = .subTitleSemiBold
  }

  let addTagButton = TextButton(type: .regular, color: .primary500).then {
    $0.leftIconImage = DesignSystemAsset.iconPlus.image
    $0.text = "태그추가"
  }

  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.register(AddedTagCell.self, forCellWithReuseIdentifier: AddedTagCell.identifier)
    $0.bounces = false
  }

  private let emptyView = UIView().then {
    $0.backgroundColor = .clear
  }

  private let emptyImage = UIImageView().then {
    $0.image = DesignSystemAsset.createLinkTagEmptyImage.image
  }

  private let emptyLabel = UILabel().then {
    $0.text = "아직 선택한 태그가 없네요\n태그를 추가해서\n저장한 링크를 나중에도 쉽게 찾아보세요"
    $0.textAlignment = .center
    $0.numberOfLines = 0
    $0.font = .bodyRegular
    $0.textColor = .gray600
  }

  private lazy var diffableDataSource = collectionViewDataSource()

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: CollectionView

  func applyAddedTag(by tags: [String]) {
    emptyView.isHidden = !tags.isEmpty

    var snapshot = NSDiffableDataSourceSnapshot<TagSection, String>()

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

  private func collectionViewDataSource() -> UICollectionViewDiffableDataSource<TagSection, String> {
    let dataSource = UICollectionViewDiffableDataSource<TagSection, String>(
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
    [titleLabel, addTagButton, collectionView, emptyView].forEach { addSubview($0) }
    [emptyImage, emptyLabel].forEach { emptyView.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.left.equalToSuperview()
    }

    addTagButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.right.equalToSuperview().inset(4.0)
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
      $0.left.right.bottom.equalToSuperview()
    }

    emptyView.snp.makeConstraints {
      $0.left.right.top.equalTo(collectionView)
    }

    emptyImage.snp.makeConstraints {
      $0.top.centerX.equalToSuperview()
      $0.size.equalTo(94.0)
    }

    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImage.snp.bottom).offset(8.0)
      $0.left.right.bottom.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
