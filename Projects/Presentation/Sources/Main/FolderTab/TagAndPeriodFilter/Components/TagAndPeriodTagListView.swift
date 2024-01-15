//
//  TagAndPeriodTagListView.swift
//  Presentation
//
//  Created by 박천송 on 12/21/23.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

protocol TagAndPeriodListViewDelegate: AnyObject {
  func tagListView(_ listView: TagAndPeriodTagListView, didSelectRowAt indexPath: IndexPath)
}

class TagAndPeriodTagListView: UIView {

  typealias Section = TagAndPeriodTagListSection
  typealias SectionItem = TagAndPeriodTagListSection.Item
  private typealias DiffableDataSource = UITableViewDiffableDataSource<Section, SectionItem>
  private typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>

  // MARK: UI

  private let emptyLabel = UILabel().then {
    $0.text = "아직 등록된 태그가 없어요."
    $0.textColor = .gray500
    $0.font = .bodyRegular
  }

  lazy var tableView = UITableView(frame: .zero, style: .plain).then {
    $0.register(TagAndPeriodTagCell.self, forCellReuseIdentifier: TagAndPeriodTagCell.identifier)
    $0.backgroundColor = .clear
    $0.delegate = self
    $0.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    $0.showsVerticalScrollIndicator = false
  }


  // MARK: Properties

  private lazy var dataSource: DiffableDataSource = diffableDataSource()

  weak var delegate: TagAndPeriodListViewDelegate?


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Layout

  private func defineLayout() {
    [emptyLabel, tableView].forEach {
      addSubview($0)
    }

    emptyLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}


// MARK: TableView

extension TagAndPeriodTagListView: UITableViewDelegate {

  private func diffableDataSource() -> DiffableDataSource {
    UITableViewDiffableDataSource<Section, SectionItem>(
      tableView: tableView
    ) { tableView, indexPath, item in
      switch item {
      case .normal(let viewModel):
        let cell = tableView.dequeueReusableCell(withIdentifier: TagAndPeriodTagCell.identifier)
          as? TagAndPeriodTagCell

        return cell?.then {
          $0.selectionStyle = .none
          $0.configure(viewModel: viewModel)
        }
      }
    }
  }

  func applyDataSource(by items: [SectionItem]) {
    var snapshot = DiffableSnapshot()
    snapshot.appendSections([.items])
    snapshot.appendItems(items)

    emptyLabel.isHidden = !items.isEmpty

    dataSource.apply(snapshot, animatingDifferences: false)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.tagListView(self, didSelectRowAt: indexPath)
  }
}
