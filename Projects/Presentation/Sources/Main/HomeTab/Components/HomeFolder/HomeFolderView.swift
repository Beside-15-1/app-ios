//
//  HomeFolderView.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

protocol HomeFolderViewDelegate: AnyObject {
  func homeFolderView(didSelectItemAt row: Int)
  func createFolderDidTapped()
}

class HomeFolderView: UIView {

  typealias Section = HomeFolderSection
  typealias SectionItem = HomeFolderCell.ViewModel
  private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, SectionItem>
  private typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>

  // MARK: UI

  private let titleLabel = UILabel().then {
    $0.attributedText = "링크 폴더".styled(font: .subTitleSemiBold, color: .staticBlack)
  }

  let moveToFolderButton = UIButton().then {
    $0.setImage(DesignSystemAsset.iconRight.image.withTintColor(.staticBlack), for: .normal)
  }

  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.register(HomeFolderCell.self, forCellWithReuseIdentifier: HomeFolderCell.identifier)
    $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    $0.delegate = self
  }


  // MARK: Properties

  private lazy var diffableDataSource = collectionViewDiffableDataSource()

  private var viewModel: HomeFolderSectionViewModel?

  weak var delegate: HomeFolderViewDelegate?


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: CollectionView

  func applyCollectionViewDataSource(by sectionViewModel: HomeFolderSectionViewModel) {
    self.viewModel = sectionViewModel

    var snapshot = DiffableSnapshot()
    snapshot.appendSections([sectionViewModel.section])
    snapshot.appendItems(sectionViewModel.items, toSection: sectionViewModel.section)

    diffableDataSource.apply(snapshot)
  }

  private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .absolute(106.0),
        heightDimension: .absolute(142.0)
      )
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .absolute(106.0),
      heightDimension: .absolute(142.0)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 1
    )

    let section = NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 16.0
    }

    let configuration = UICollectionViewCompositionalLayoutConfiguration().then {
      $0.scrollDirection = .horizontal
    }

    return UICollectionViewCompositionalLayout(
      section: section,
      configuration: configuration
    )
  }

  private func collectionViewDiffableDataSource() -> DiffableDataSource {
    UICollectionViewDiffableDataSource<Section, SectionItem>(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      collectionView.dequeueReusableCell(
        withReuseIdentifier: HomeFolderCell.identifier,
        for: indexPath
      ).then {
        guard let cell = $0 as? HomeFolderCell else { return }
        cell.configure(viewModel: item)
      }
    }
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(titleLabel)
    addSubview(moveToFolderButton)
    addSubview(collectionView)

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.left.equalToSuperview().inset(20.0)
    }

    moveToFolderButton.snp.makeConstraints {
      $0.size.equalTo(24.0)
      $0.left.equalTo(titleLabel.snp.right).offset(4.0)
      $0.bottom.equalTo(titleLabel)
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
      $0.left.right.equalToSuperview()
      $0.bottom.equalToSuperview().inset(8.0)
      $0.height.equalTo(147)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}

extension HomeFolderView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let viewModel else { return }

    guard viewModel.items.count != indexPath.row + 1 else {
      delegate?.createFolderDidTapped()
      return
    }

    delegate?.homeFolderView(didSelectItemAt: indexPath.row)
  }
}
