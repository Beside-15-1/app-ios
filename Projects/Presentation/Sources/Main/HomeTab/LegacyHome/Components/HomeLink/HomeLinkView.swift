//
//  HomeLinkView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/06.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

protocol HomeLinkViewDelegate: AnyObject {
  func homeLinkView(_ homeLinkView: HomeLinkView, didSelectItemAt row: Int)
}

class HomeLinkView: UIView {

  typealias Section = HomeLinkSection
  typealias SectionItem = HomeLinkCell.ViewModel
  private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, SectionItem>
  private typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>

  // MARK: UI

  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.register(HomeLinkCell.self, forCellWithReuseIdentifier: HomeLinkCell.identifier)
    $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    $0.delegate = self
  }

  private let emptyView = UIView()

  private let newLinkImage = UIImageView().then {
    $0.image = DesignSystemAsset.imgLink.image.withTintColor(.staticBlack)
  }

  let newLinkButton = SmallButton(priority: .primary).then {
    $0.text = "새 링크 저장하기"
    $0.icon = DesignSystemAsset.iconPlus.image
  }


  // MARK: Properties

  private lazy var diffableDataSource = collectionViewDiffableDataSource()

  weak var delegate: HomeLinkViewDelegate?

  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: CollectionView

  func applyCollectionViewDataSource(by sectionViewModel: HomeLinkSectionViewModel) {
    emptyView.isHidden = !sectionViewModel.items.isEmpty

    var snapshot = DiffableSnapshot()
    snapshot.appendSections([sectionViewModel.section])
    snapshot.appendItems(sectionViewModel.items, toSection: sectionViewModel.section)

    diffableDataSource.apply(snapshot)
  }

  private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .absolute(212.0),
        heightDimension: .absolute(238.0)
      )
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .absolute(212.0),
      heightDimension: .absolute(238.0)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 1
    )

    let section = NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 12.0
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
        withReuseIdentifier: HomeLinkCell.identifier,
        for: indexPath
      ).then {
        guard let cell = $0 as? HomeLinkCell else { return }
        cell.configure(viewModel: item)
      }
    }
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(collectionView)
    addSubview(emptyView)
    emptyView.addSubview(newLinkButton)
    emptyView.addSubview(newLinkImage)

    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(243)
    }

    emptyView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.right.equalToSuperview().inset(20)
      $0.height.equalTo(243)
    }

    newLinkImage.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().inset(16.0)
      $0.width.equalTo(295)
      $0.height.equalTo(142)
    }

    newLinkButton.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20.0)
      $0.bottom.equalToSuperview().inset(16.0)
    }
  }

  private func setEmptyView() {
    // 코너 반경 설정
    emptyView.layer.cornerRadius = 8

    // 그림자 설정
    emptyView.layer.shadowColor = UIColor.black.cgColor
    emptyView.layer.shadowOpacity = 0.1
    emptyView.layer.shadowOffset = CGSize(width: 0, height: 4)
    emptyView.layer.shadowRadius = 2

    // 그림자 경로 설정 (코너 반경을 고려)
    emptyView.layer.shadowPath = UIBezierPath(
      roundedRect: emptyView.bounds,
      cornerRadius: emptyView.layer.cornerRadius
    ).cgPath

    // 그림자를 보여주기 위해 배경색 설정 (선택 사항)
    emptyView.backgroundColor = .paperCard
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    setEmptyView()
  }
}


extension HomeLinkView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.homeLinkView(self, didSelectItemAt: indexPath.row)
  }
}
