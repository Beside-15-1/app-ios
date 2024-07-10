//
//  HomeFeedView.swift
//  Presentation
//
//  Created by 박천송 on 6/21/24.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class HomeFeedView: UIView {

  // MARK: UI

  private let listView = HomeFeedListView()

  private let colorBackground = UIView().then {
    $0.backgroundColor = .paperAboveBg
  }

  let navigationBar = MainNavigationBar(style: .home)


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configureDataSource(
    by sectionViewModels: [SectionViewModel<HomeFeedModel.Section, HomeFeedModel.Item>]
  ) {
    listView.update(sections: sectionViewModels)
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(colorBackground)
    addSubview(navigationBar)
    addSubview(listView)

    navigationBar.snp.makeConstraints {
      $0.left.right.top.equalTo(safeAreaLayoutGuide)
    }

    colorBackground.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.bottom.equalTo(navigationBar.snp.top)
    }

    listView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom)
      $0.bottom.left.right.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
