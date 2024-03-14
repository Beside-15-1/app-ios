//
//  CreateFolderView.swift
//  ShareExtension
//
//  Created by 박천송 on 3/14/24.
//  Copyright © 2024 PinkBoss Inc. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import SnapKit
import Then

import DesignSystem

class CreateFolderView: UIView {

  // MARK: UI

  let titleView = TitleView().then {
    $0.title = "새폴더"
  }

  let previewView = CreateFolderPreviewView()

  let linkBookTabView = CreateFolderTabView()


  // MARK: Properties

  private let disposeBag = DisposeBag()


  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .paperWhite

    defineLayout()

    linkBookTabView.tabView.selectedTab
      .subscribe(with: self) { `self`, _ in
        self.endEditing(true)
      }
      .disposed(by: disposeBag)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: Layout

  private func defineLayout() {
    addSubview(titleView)
    addSubview(previewView)
    addSubview(linkBookTabView)

    titleView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }

    previewView.snp.makeConstraints { make in
      make.width.centerX.equalToSuperview()
      make.height.equalTo(260)
      make.top.equalTo(titleView.snp.bottom)
    }

    linkBookTabView.snp.makeConstraints { make in
      make.width.centerX.bottom.equalToSuperview()
      make.top.equalTo(previewView.snp.bottom)
    }
  }
}
