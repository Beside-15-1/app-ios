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
import Domain
import PBLog

protocol FolderDetailListViewDelegate: AnyObject {
  func listViewItemDidTapped(at row: Int)
  func listViewMoreButtonTapped(id: String)
  func listViewCheckBoxTapped(id: String)
  func listViewDidScroll(_ scrollView: UIScrollView)
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


  // 편집중이 아닐때

  let totalCountLabel = UILabel()

  private let noEditingContainer = UIView()
  private let noEditDivider = UIView().then {
    $0.backgroundColor = .gray600
  }

  let sortButton = TextButton(type: .regular, color: .gray600).then {
    $0.text = "생성순"
    $0.rightIconImage = DesignSystemAsset.iconDown.image
  }

  let editButton = TextButton(type: .regular, color: .gray600).then {
    $0.text = "편집"
  }

  // 편집중

  private let totalCountContainer = UIView().then {
    $0.isHidden = true
  }

  let selectAllCheckBox = CheckBox(type: .fill).then {
    $0.scale = .small
  }

  private let selectAllTitleLabel = UILabel().then {
    $0.attributedText = "모두 선택".styled(font: .defaultSemiBold, color: .gray600)
  }

  private let selectAllCountLabel = UILabel()

  private let editingContainer = UIView().then {
    $0.isHidden = true
  }

  private let editDivider = UIView().then {
    $0.backgroundColor = .gray600
  }

  let endEditingButton = TextButton(type: .regular, color: .gray600).then {
    $0.text = "편집 종료"
  }

  let deleteButton = TextButton(type: .regular, color: .gray600).then {
    $0.text = "삭제"
  }

  // MARK: Properties

  private lazy var diffableDataSource = self.collectionViewDiffableDataSource()

  var isEditing = false
  var selectedLinkListOnEditingMode: [String] = []

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

  func applyCollectionViewDataSource(
    by sectionViewModel: FolderDetailSectionViewModel
  ) {
    guard !sectionViewModel.items.isEmpty else {
      collectionView.isHidden = true
      totalCountLabel.attributedText = "0개 주섬"
        .styled(font: .subTitleSemiBold, color: .gray800)
      selectAllCountLabel.attributedText = "0/\(sectionViewModel.items.count)개".styled(
        font: .defaultSemiBold,
        color: .gray800
      )
      return
    }

    collectionView.isHidden = false

    var snapshot = DiffableSnapshot()
    snapshot.appendSections([sectionViewModel.section])
    snapshot.appendItems(sectionViewModel.items, toSection: sectionViewModel.section)

    diffableDataSource.apply(snapshot)

    var selectedItemCount = 0
    sectionViewModel.items.forEach { item in
      if selectedLinkListOnEditingMode.contains(where: { $0 == item.id }) {
        selectedItemCount += 1
      }
    }

    totalCountLabel.attributedText = "\(sectionViewModel.items.count)개 주섬"
      .styled(font: .bodySemiBold, color: .gray800)
    selectAllCountLabel.attributedText = "\(selectedItemCount)/\(sectionViewModel.items.count)개".styled(
      font: .defaultSemiBold,
      color: .gray800
    )
  }

  private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1),
        heightDimension: .absolute(148)
      )
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .absolute(148)
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
      ).then { [weak self] cell in
        guard let self,
              let cell = cell as? FolderDetailCell else { return }
        cell.configure(viewModel: item)

        cell.moreButton.rx.tap
          .subscribe(onNext: { _ in
            self.delegate?.listViewMoreButtonTapped(id: item.id)
          })
          .disposed(by: cell.disposeBag)

        cell.checkBox.rx.controlEvent(.touchUpInside)
          .subscribe(onNext: { _ in
            if let index = self.selectedLinkListOnEditingMode.firstIndex(where: { $0 == item.id }) {
              self.selectedLinkListOnEditingMode.remove(at: index)
            } else {
              self.selectedLinkListOnEditingMode.append(item.id)
            }
            self.delegate?.listViewCheckBoxTapped(id: item.id)
          })
          .disposed(by: cell.disposeBag)

        cell.checkBox.isSelected = selectedLinkListOnEditingMode.contains(
          where: {
            $0 == item.id
          }
        )
      }
    }
  }

  func updateSelectedLinkListOnEditingMode(list: [String]) {
    selectedLinkListOnEditingMode = list
  }

  func configureCheckBox() {
    collectionView.visibleCells.forEach { cell in
      guard let cell = cell as? FolderDetailCell else {
        return
      }

      if selectedLinkListOnEditingMode.contains(where: { $0 == cell.viewModel?.id }) {
        cell.checkBox.isSelected = true
      } else {
        cell.checkBox.isSelected = false
      }
    }
  }

  func configureEditingContainer(isEditing: Bool) {
    noEditingContainer.isHidden = isEditing
    totalCountLabel.isHidden = isEditing
    editingContainer.isHidden = !isEditing
    totalCountContainer.isHidden = !isEditing
  }

  func configureSelectAllCountLabel(selected: Int, total: Int) {
    selectAllCountLabel.attributedText = "\(selected)/\(total)개".styled(font: .defaultSemiBold, color: .gray800)
  }


  // MARK: Layout

  private func defineLayout() {
    [totalCountLabel, totalCountContainer, emptyLabel, collectionView, noEditingContainer, editingContainer]
      .forEach { addSubview($0) }

    [selectAllCheckBox, selectAllTitleLabel, selectAllCountLabel].forEach { totalCountContainer.addSubview($0) }
    [sortButton, noEditDivider, editButton].forEach { noEditingContainer.addSubview($0) }
    [deleteButton, editDivider, endEditingButton].forEach { editingContainer.addSubview($0) }
    collectionView.addSubview(refreshControl)

    totalCountLabel.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.top.equalToSuperview().inset(24.0)
    }

    noEditingContainer.snp.makeConstraints {
      $0.right.equalToSuperview()
      $0.top.equalToSuperview().inset(24.0)
    }

    sortButton.snp.makeConstraints {
      $0.left.top.bottom.equalToSuperview()
    }

    editButton.snp.makeConstraints {
      $0.left.equalTo(sortButton.snp.right).offset(8.0)
      $0.right.top.bottom.equalToSuperview()
    }

    editingContainer.snp.makeConstraints {
      $0.right.equalToSuperview()
      $0.top.equalToSuperview().inset(24.0)
    }

    editDivider.snp.makeConstraints {
      $0.width.equalTo(2.0)
      $0.height.equalTo(14.5)
      $0.left.equalTo(deleteButton.snp.right).offset(10.0)
      $0.centerY.equalToSuperview()
    }

    deleteButton.snp.makeConstraints {
      $0.left.top.bottom.equalToSuperview()
    }

    endEditingButton.snp.makeConstraints {
      $0.left.equalTo(editDivider.snp.right).offset(10)
      $0.right.top.bottom.equalToSuperview()
    }

    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(sortButton.snp.bottom).offset(120.0)
      $0.centerX.equalToSuperview()
    }

    collectionView.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
      $0.top.equalTo(sortButton.snp.bottom).offset(18.0)
    }

    totalCountContainer.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.top.equalToSuperview().inset(24.0)
    }

    selectAllCheckBox.snp.makeConstraints {
      $0.left.centerY.equalToSuperview()
    }

    selectAllTitleLabel.snp.makeConstraints {
      $0.left.equalTo(selectAllCheckBox.snp.right).offset(8.0)
      $0.top.bottom.equalToSuperview()
    }

    selectAllCountLabel.snp.makeConstraints {
      $0.left.equalTo(selectAllTitleLabel.snp.right).offset(8.0)
      $0.right.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
}


extension FolderDetailListView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.listViewItemDidTapped(at: indexPath.row)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    delegate?.listViewDidScroll(scrollView)
  }
}


extension FolderDetailListView: FolderDetailCellDelegate {
  func folderDetailCellCheckBoxTapped(id: String) {
    delegate?.listViewCheckBoxTapped(id: id)
  }

  func folderDetailCellMoreButtonTapped(id: String) {
    delegate?.listViewMoreButtonTapped(id: id)
  }
}
