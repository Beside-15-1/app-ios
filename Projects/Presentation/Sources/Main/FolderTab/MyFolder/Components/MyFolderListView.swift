//
//  MyFolderListView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/14.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem
import PBLog

protocol MyFolderCollectionViewDelegate: AnyObject {
  func collectionViewItemDidTapped(at row: Int)
  func collectionViewEditButtonTapped(id: String)
}

class MyFolderListView: UIView {

  typealias Section = MyFolderSection
  typealias SectionItem = MyFolderCell.ViewModel
  private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, SectionItem>
  private typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>

  // MARK: UI

  let sortButton = TextButton(type: .regular, color: .gray700).then {
    $0.text = "생성순"
    $0.rightIconImage = DesignSystemAsset.iconDown.image
  }

  let createFolderButton = TextButton(type: .regular, color: .primary500).then {
    $0.text = "폴더추가"
    $0.leftIconImage = DesignSystemAsset.iconPlus.image
  }

  lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.collectionViewLayout()
  ).then {
    $0.register(MyFolderCell.self, forCellWithReuseIdentifier: MyFolderCell.identifier)
    $0.backgroundColor = .staticWhite
    $0.showsVerticalScrollIndicator = false
    $0.delegate = self
  }

  let emptyLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }


  // MARK: Properties

  var viewModel: MyFolderSectionViewModel?

  private lazy var diffableDataSource = self.collectionViewDiffableDataSource()

  weak var delegate: MyFolderCollectionViewDelegate?

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperWhite

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configureEmptyLabel(text: String) {
    emptyLabel.attributedText = "검색한 ‘\(text)' 폴더가 없어요\n폴더를 추가해보세요."
      .styled(
        font: .defaultRegular,
        color: .gray700
      )
      .font(font: .defaultBold, target: text)
  }


  // MARK: CollectionView

  func applyCollectionViewDataSource(by sectionViewModel: MyFolderSectionViewModel) {
    guard !sectionViewModel.items.isEmpty else {
      collectionView.isHidden = true
      return
    }

    self.viewModel = sectionViewModel
    collectionView.isHidden = false

    var snapshot = DiffableSnapshot()
    snapshot.appendSections([sectionViewModel.section])
    snapshot.appendItems(sectionViewModel.items, toSection: sectionViewModel.section)

    diffableDataSource.apply(snapshot)
  }

  private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1/3),
        heightDimension: .fractionalWidth(1.6/3)
      )
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1.6/3)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 3
    ).then {
      $0.interItemSpacing = .fixed(8.5)
    }

    let section = NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 12.0
    }

    let configuration = UICollectionViewCompositionalLayoutConfiguration().then {
      $0.scrollDirection = .vertical
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
        withReuseIdentifier: MyFolderCell.identifier,
        for: indexPath
      ).then {
        guard let cell = $0 as? MyFolderCell else { return }
        cell.configure(viewModel: item)
        cell.moreButton.rx.tap
          .subscribe(onNext: { [weak self] in
            self?.delegate?.collectionViewEditButtonTapped(id: item.id)
          })
          .disposed(by: cell.disposeBag)
      }
    }
  }


  // MARK: Layout

  private func defineLayout() {
    [sortButton, createFolderButton, emptyLabel, collectionView].forEach { addSubview($0) }

    sortButton.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.top.equalToSuperview().inset(24.0)
    }

    createFolderButton.snp.makeConstraints {
      $0.right.equalToSuperview()
      $0.top.equalToSuperview().inset(24.0)
    }

    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(sortButton.snp.bottom).offset(120.0)
      $0.centerX.equalToSuperview()
    }

    collectionView.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
      $0.top.equalTo(sortButton.snp.bottom).offset(18.0)
    }
  }
}


extension MyFolderListView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.collectionViewItemDidTapped(at: indexPath.row)
  }
}
