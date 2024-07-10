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


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configureDataSource(by sectionViewModels: [HomeFeedSectionViewModel]) {
    listView.applyCollectionViewDataSource(by: sectionViewModels)
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(listView)

    listView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
