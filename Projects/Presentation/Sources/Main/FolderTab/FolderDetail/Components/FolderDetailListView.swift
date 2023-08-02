//
//  FolderDetailListView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/17.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem
import PBLog

protocol FolderDetailListViewDelegate: AnyObject {
  func listViewItemDidTapped(at row: Int)
  func listViewMoreButtonTapped(id: String)
}

class FolderDetailListView: UIView {

  struct EmptyViewModel: Hashable {
    let text: String
    let bold: String
  }

  typealias Section = FolderDetailSection
  typealias SectionItem = FolderDetailCell.ViewModel
  private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, SectionItem>
  private typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>


  // MARK: UI

  let totalCountLabel = UILabel()

  let sortButton = TextButton(type: .regular, color: .gray600).then {
    $0.text = "생성순"
    $0.rightIconImage = DesignSystemAsset.iconDown.image
  }

  lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.collectionViewLayout()
  ).then {
    $0.register(FolderDetailCell.self, forCellWithReuseIdentifier: FolderDetailCell.identifier)
    $0.backgroundColor = .staticWhite
    $0.showsVerticalScrollIndicator = false
    $0.delegate = self
  }

  let emptyLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }

  let refreshControl = UIRefreshControl()


  // MARK: Properties

  private lazy var diffableDataSource = self.collectionViewDiffableDataSource()

  weak var delegate: FolderDetailListViewDelegate?


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

  func configureTotalCount(count: Int) {
    totalCountLabel.attributedText = "\(count)개 주섬"
      .styled(font: .subTitleSemiBold, color: .gray800)
  }

  func configureEmptyLabel(viewModel: EmptyViewModel) {
    emptyLabel.attributedText = viewModel.text
      .styled(
        font: .defaultRegular,
        color: .gray700
      )
      .font(font: .defaultBold, target: viewModel.bold)

    emptyLabel.textAlignment = .center
  }


  // MARK: CollectionView

  func applyCollectionViewDataSource(by sectionViewModel: FolderDetailSectionViewModel) {
    guard !sectionViewModel.items.isEmpty else {
      collectionView.isHidden = true
      return
    }

    collectionView.isHidden = false

    var snapshot = DiffableSnapshot()
    snapshot.appendSections([sectionViewModel.section])
    snapshot.appendItems(sectionViewModel.items, toSection: sectionViewModel.section)

    diffableDataSource.apply(snapshot)
  }

  private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1),
        heightDimension: .absolute(124)
      )
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .absolute(124)
    )

    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: groupSize,
      subitem: item,
      count: 1
    )

    let section = NSCollectionLayoutSection(group: group)

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
        withReuseIdentifier: FolderDetailCell.identifier,
        for: indexPath
      ).then {
        guard let cell = $0 as? FolderDetailCell else { return }
        cell.configure(viewModel: item)
        cell.moreButton.rx.tap
          .subscribe(onNext: { [weak self] in
            self?.delegate?.listViewMoreButtonTapped(id: item.id)
          })
          .disposed(by: cell.disposeBag)
      }
    }
  }


  // MARK: Layout

  private func defineLayout() {
    [totalCountLabel ,sortButton, emptyLabel, collectionView].forEach { addSubview($0) }
    collectionView.addSubview(refreshControl)

    totalCountLabel.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.top.equalToSuperview().inset(24.0)
    }

    sortButton.snp.makeConstraints {
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


extension FolderDetailListView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.listViewItemDidTapped(at: indexPath.row)
  }
}
