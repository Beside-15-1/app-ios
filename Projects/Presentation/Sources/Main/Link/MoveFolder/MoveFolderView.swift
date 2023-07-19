//
//  MoveFolderView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/19.
//

import UIKit

import SnapKit
import Then

import DesignSystem

protocol MoveFolderViewDelegate: AnyObject {
  func collectionView(didSelectItemAt indexPath: IndexPath)
}

final class MoveFolderView: UIView {

  typealias Section = MoveFolderSection
  typealias SectionItem = MoveFolderCell.ViewModel
  private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, SectionItem>
  private typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>

  // MARK: UI

  let titleView = TitleView().then {
    $0.title = "폴더 이동"
  }

  lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.register(MoveFolderCell.self, forCellWithReuseIdentifier: MoveFolderCell.identifier)
    $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    $0.delegate = self
  }

  let saveButton = BasicButton(priority: .primary).then {
    $0.text = "저장하기"
  }


  // MARK: Properties

  private lazy var diffableDataSource = collectionViewDiffableDataSource()

  weak var delegate: MoveFolderViewDelegate?

  var isFirst = true

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperWhite

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: CollectionView

  func applyCollectionViewDataSource(by sectionViewModel: MoveFolderSectionViewModel) {
    var snapshot = DiffableSnapshot()
    snapshot.appendSections([sectionViewModel.section])
    snapshot.appendItems(sectionViewModel.items, toSection: sectionViewModel.section)

    diffableDataSource.apply(snapshot)

    let row = sectionViewModel.items.firstIndex { viewModel in
      viewModel.isCurrentFolder
    }

    if isFirst {
      collectionView.selectItem(
        at: IndexPath(item: row ?? 0, section: 0),
        animated: true,
        scrollPosition: .centeredHorizontally
      )
      isFirst = false
    }
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
      $0.interGroupSpacing = 8.0
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
        withReuseIdentifier: MoveFolderCell.identifier,
        for: indexPath
      ).then {
        guard let cell = $0 as? MoveFolderCell else { return }
        cell.configure(viewModel: item)
      }
    }
  }


  // MARK: Layout

  private func defineLayout() {
    [titleView, collectionView, saveButton].forEach { addSubview($0) }

    titleView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleView.snp.bottom).offset(24.0)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(146.0)
    }

    saveButton.snp.makeConstraints {
      $0.top.equalTo(collectionView.snp.bottom).offset(30.0)
      $0.left.right.equalToSuperview().inset(20.0)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(20.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}


extension MoveFolderView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.collectionView(didSelectItemAt: indexPath)
  }
}
