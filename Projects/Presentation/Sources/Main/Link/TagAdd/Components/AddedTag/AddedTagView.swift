import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

import DesignSystem

// MARK: - AddedTagSection

enum AddedTagSection {
  case normal
}

// MARK: - AddedTagItem

struct AddedTagItem: Hashable {
  let tag: String
  let row: Int
}

// MARK: - AddedTagViewDelegate

protocol AddedTagViewDelegate: AnyObject {
  func removeAddedTag(at row: Int)
}

// MARK: - AddedTagView

class AddedTagView: UIView {
  // MARK: UI

  private let titleLabel = UILabel().then {
    $0.text = "추가한 태그"
    $0.textColor = .staticBlack
    $0.font = .subTitleSemiBold
  }

  private let tagCountLabel = UILabel().then {
    $0.textColor = .gray600
    $0.font = .defaultRegular
  }

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
    $0.text = "아직 선택된 태그가 없어요\n태그는 10개까지 선택할 수 있어요"
    $0.textColor = .gray500
    $0.textAlignment = .center
    $0.font = .bodyRegular
    $0.numberOfLines = 0
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


  // MARK: Configuring

  func configureTagCount(count: Int) {
    tagCountLabel.text = "\(count)/10"
  }
  

  // MARK: CollectionView

  func applyAddedTag(by tags: [String]) {
    emptyLabel.isHidden = !tags.isEmpty

    var snapshot = NSDiffableDataSourceSnapshot<AddedTagSection, AddedTagItem>()

    let items = tags.map { AddedTagItem(tag: $0, row: tags.firstIndex(of: $0) ?? 0) }

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

  private func collectionViewDataSource() -> UICollectionViewDiffableDataSource<AddedTagSection, AddedTagItem> {
    let dataSource = UICollectionViewDiffableDataSource<AddedTagSection, AddedTagItem>(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      collectionView.dequeueReusableCell(
        withReuseIdentifier: AddedTagCell.identifier, for: indexPath
      ).then {
        guard let cell = $0 as? AddedTagCell else { return }
        cell.configureText(text: item.tag)
        cell.deleteButton.rx.tap
          .subscribe(onNext: { [weak self] in
            self?.delegate?.removeAddedTag(at: item.row)
          })
          .disposed(by: cell.disposeBag)
      }
    }

    return dataSource
  }

  // MARK: Layout

  private func defineLayout() {
    addSubview(titleLabel)
    addSubview(tagCountLabel)
    addSubview(emptyLabel)
    addSubview(collectionView)

    titleLabel.snp.makeConstraints {
      $0.top.left.equalToSuperview()
    }

    tagCountLabel.snp.makeConstraints {
      $0.left.equalTo(titleLabel.snp.right).offset(8.0)
      $0.bottom.equalTo(titleLabel)
    }

    emptyLabel.snp.makeConstraints {
      $0.center.equalTo(collectionView)
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10.0)
      $0.left.right.bottom.equalToSuperview()
      $0.height.equalTo(28.0)
    }
  }
}

// MARK: UICollectionViewDelegate

extension AddedTagView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}
