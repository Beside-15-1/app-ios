//
//  HomeFeedTagView.swift
//  Presentation
//
//  Created by 박천송 on 6/25/24.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

protocol HomeFeedTabViewDelegate: AnyObject {
  func homeFeedTabViewRecentlySavedButtonTapped()
  func homeFeedTabViewNoReadButtonTapped()
}

enum HomeFeedTab: String {
  case noRead = "읽지 않음"
  case recentlySaved = "최근 저장"
}

final class HomeFeedTabView: UIView {

  // MARK: Contants

  private enum Color {
    static let selected = UIColor.white
    static let deselected = UIColor.gray500
  }

  private enum Font {
    static let selected = UIFont.subTitleBold
    static let deselected = UIFont.subTitleRegular
  }


  // MARK: UI

  private let recentlySavedTab = UIControl()

  private let recentlySavedLabel = UILabel().then {
    $0.attributedText = HomeFeedTab.recentlySaved.rawValue.styled(
      font: Font.selected,
      color: Color.selected
    )
  }

  private let recentlySavedUnderBar = UIView().then {
    $0.backgroundColor = .white
  }

  private let noReadTab = UIControl()

  private let noReadLabel = UILabel().then {
    $0.attributedText = HomeFeedTab.noRead.rawValue.styled(
      font: Font.deselected,
      color: Color.deselected
    )
  }

  private let noReadUnderBar = UIView().then {
    $0.backgroundColor = .white
    $0.isHidden = true
  }


  // MARK: Properties

  weak var delegate: HomeFeedTabViewDelegate?


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .paperAboveBg

    defineLayout()
    addAction()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  func configureTab(tab: HomeFeedTab) {
    switch tab {
    case .noRead:
      recentlySavedLabel.attributedText = HomeFeedTab.recentlySaved.rawValue.styled(
        font: Font.deselected, color: Color.deselected
      )
      noReadLabel.attributedText = HomeFeedTab.noRead.rawValue.styled(
        font: Font.selected, color: Color.selected
      )
      recentlySavedUnderBar.isHidden = true
      noReadUnderBar.isHidden = false


    case .recentlySaved:
      noReadLabel.attributedText = HomeFeedTab.noRead.rawValue.styled(
        font: Font.deselected, color: Color.deselected
      )
      recentlySavedLabel.attributedText = HomeFeedTab.recentlySaved.rawValue.styled(
        font: Font.selected, color: Color.selected
      )
      recentlySavedUnderBar.isHidden = false
      noReadUnderBar.isHidden = true
    }
  }


  // MARK: Action

  private func addAction() {
    recentlySavedTab.addAction(UIAction(handler: { [weak self] _ in
      self?.delegate?.homeFeedTabViewRecentlySavedButtonTapped()
    }), for: .touchUpInside)

    noReadTab.addAction(UIAction(handler: { [weak self] _ in
      self?.delegate?.homeFeedTabViewNoReadButtonTapped()
    }), for: .touchUpInside)
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(recentlySavedTab)
    recentlySavedTab.addSubview(recentlySavedLabel)
    recentlySavedTab.addSubview(recentlySavedUnderBar)
    addSubview(noReadTab)
    noReadTab.addSubview(noReadLabel)
    noReadTab.addSubview(noReadUnderBar)

    recentlySavedTab.snp.makeConstraints {
      $0.left.top.bottom.equalToSuperview()
      $0.width.equalTo(UIScreen.main.bounds.width / 2)
    }

    noReadTab.snp.makeConstraints {
      $0.right.top.bottom.equalToSuperview()
      $0.width.equalTo(UIScreen.main.bounds.width / 2)
    }

    recentlySavedLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    recentlySavedUnderBar.snp.makeConstraints {
      $0.left.equalTo(recentlySavedLabel.snp.left).offset(-1.0)
      $0.right.equalTo(recentlySavedLabel.snp.right).offset(1.0)
      $0.height.equalTo(2)
      $0.bottom.equalToSuperview()
    }

    noReadLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    noReadUnderBar.snp.makeConstraints {
      $0.left.equalTo(noReadLabel.snp.left).offset(-1.0)
      $0.right.equalTo(noReadLabel.snp.right).offset(1.0)
      $0.height.equalTo(2)
      $0.bottom.equalToSuperview()
    }
  }
}
