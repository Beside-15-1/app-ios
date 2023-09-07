//
//  MasterView.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/28.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class MasterView: UIView {

  typealias Section = MasterSection
  typealias SectionItem = MasterTabCell.ViewModel
  private typealias DiffableDataSource = UITableViewDiffableDataSource<Section, SectionItem>
  private typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>

  // MARK: UI

  private let topContainer = UIView()

  private let logo = UILabel().then {
    $0.attributedText = "Joosum".styled(font: .logo, color: .staticBlack)
  }

  let masterDetailButton = UIButton().then {
    $0.setImage(DesignSystemAsset.iconMasterDetail.image.withTintColor(.staticBlack), for: .normal)
  }

  lazy var tableView = UITableView(frame: .zero, style: .plain).then {
    $0.register(MasterTabCell.self, forCellReuseIdentifier: MasterTabCell.identifier)
    $0.backgroundColor = .clear
    $0.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    $0.separatorStyle = .none
    $0.bounces = false
  }


  // MARK: Properties

  private lazy var diffableDataSource = self.tableViewDataSource()

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .gray300

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: DataSource

  func applyTableViewDataSource(
    by viewModels: [MasterTabCell.ViewModel]
  ) {
    var snapshot = DiffableSnapshot()

    snapshot.appendSections([.normal])
    snapshot.appendItems(viewModels, toSection: .normal)

    diffableDataSource.apply(snapshot)
  }

  private func tableViewDataSource() -> DiffableDataSource {

    let dataSource = UITableViewDiffableDataSource<Section, SectionItem>(
      tableView: tableView
    ) { tableView, indexPath, item in

      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: MasterTabCell.identifier,
        for: indexPath
      ) as? MasterTabCell else { return UITableViewCell() }

      return cell.then {
        $0.configure(viewModel: item)
      }
    }

    return dataSource
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
  }

  private func defineLayout() {
    [topContainer, tableView].forEach { addSubview($0) }
    [masterDetailButton, logo].forEach { topContainer.addSubview($0) }

    topContainer.snp.makeConstraints {
      $0.left.right.equalTo(safeAreaLayoutGuide).inset(20.0)
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.height.equalTo(44.0)
    }

    logo.snp.makeConstraints {
      $0.left.centerY.equalToSuperview()
    }

    masterDetailButton.snp.makeConstraints {
      $0.right.centerY.equalToSuperview()
    }

    tableView.snp.makeConstraints {
      $0.left.right.bottom.equalTo(safeAreaLayoutGuide)
      $0.top.equalTo(topContainer.snp.bottom).offset(24.0)
    }
  }
}
