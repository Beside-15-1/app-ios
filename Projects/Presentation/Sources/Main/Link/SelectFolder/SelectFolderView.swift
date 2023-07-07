//
//  SelectFolderView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/04.
//

import UIKit

import FlexLayout
import PinLayout
import SnapKit
import Then

import DesignSystem
import Domain

final class SelectFolderView: UIView {

  typealias Section = SelectFolderSection
  typealias SectionItem = Folder
  private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, SectionItem>
  private typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>


  // MARK: UI

  let titleView = TitleView().then {
    $0.title = "저장할 폴더"
  }

  lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.collectionViewLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.showsVerticalScrollIndicator = false
    $0.register(SelectFolderCell.self, forCellWithReuseIdentifier: SelectFolderCell.identifier)
  }

  private lazy var diffableDataSource = self.collectionViewDataSource()

  private var selectedFolder: Folder = .init()

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .paperWhite

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func applyCollectionViewDataSource(
    by folders: [Folder],
    selectedFolder folder: Folder
  ) {
    self.selectedFolder = folder

    var snapshot = DiffableSnapshot()

    snapshot.appendSections([.myFolder])
    snapshot.appendItems(folders, toSection: .myFolder)

    diffableDataSource.apply(snapshot)
  }

  // MARK: CollectionView

  private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(48.0)
      )
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(48.0)
    )

    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: groupSize,
      subitem: item,
      count: 1
    )

    let section = NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 4.0
    }

    return UICollectionViewCompositionalLayout(section: section)
  }

  private func collectionViewDataSource() -> DiffableDataSource {
    let dataSource = UICollectionViewDiffableDataSource<Section, SectionItem>(
      collectionView: collectionView
    ) { [weak self] collectionView, indexPath, item in

      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SelectFolderCell.identifier,
        for: indexPath
      ) as? SelectFolderCell else { return UICollectionViewCell() }

      return cell.then {
        $0.configure(
          with: item,
          isSelected: item == self?.selectedFolder ?? .init()
        )
      }
    }

    return dataSource
  }


  // MARK: Layout

  private func defineLayout() {
    [titleView, collectionView].forEach {
      addSubview($0)
    }

    titleView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleView.snp.bottom).offset(12.0)
      $0.left.right.equalToSuperview().inset(20.0)
      $0.bottom.equalToSuperview().inset(8.0)
      //      $0.height.equalTo(0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
