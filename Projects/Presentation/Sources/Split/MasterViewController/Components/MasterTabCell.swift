//
//  MasterTabCell.swift
//  Presentation
//
//  Created by 박천송 on 2023/09/06.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

class MasterTabCell: UITableViewCell {
  static let identifier = "MasterTabCell"

  struct ViewModel: Hashable {
    let tabViewType: MasterTabCellTabView.ViewType?
    let folderViewModel: MasterTabCellFolderView.ViewModel?
    let isMakeButton: Bool
  }

  // MARK: UI

  private let tabView = MasterTabCellTabView().then {
    $0.isHidden = true
  }

  private let folderView = MasterTabCellFolderView().then {
    $0.isHidden = true
  }

  private let makeFolderView = MasterTabCellMakeFolderView().then {
    $0.isHidden = true
  }


  // MARK: Initialize

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    defineLayout()

    contentView.backgroundColor = .gray300
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func prepareForReuse() {
    tabView.isHidden = true
    folderView.isHidden = true
    makeFolderView.isHidden = true
  }

  // MARK: Configuring

  func configure(viewModel: ViewModel) {
    if let tabViewType = viewModel.tabViewType {
      tabView.isHidden = false
      tabView.configure(type: tabViewType)
    }

    if let folderViewModel = viewModel.folderViewModel {
      folderView.isHidden = false
      folderView.configure(viewModel: folderViewModel)
    }

    if viewModel.isMakeButton {
      makeFolderView.isHidden = false
    }
  }


  // MARK: Layout

  private func defineLayout() {
    [tabView, folderView, makeFolderView].forEach {
      contentView.addSubview($0)
      $0.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }
    }
  }
}

