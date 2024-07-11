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

final class HomeFeedTagView: UIView {

  // MARK: UI

  private let contentView = UIView()

  private var tagList: [UIView] = []


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .paperWhite

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(contentView)

    contentView.snp.makeConstraints {
      $0.left.top.bottom.equalToSuperview()
    }
  }

  func configureTags(tags: [String]) {
    if !tagList.isEmpty {
      tagList.forEach {
        $0.removeFromSuperview()
      }
      tagList.removeAll()
    }

    let totalWidth = UIScreen.main.bounds.width - 40 - 32

    var remainWidth = totalWidth

    tags.enumerated().forEach { index, tag in
      let label = UILabel().then {
        $0.attributedText = "#\(tag)".styled(font: .captionRegular, color: .staticBlack)
        $0.textAlignment = .center
      }
      label.sizeToFit()

      let width = label.frame.width + 16.0

      guard remainWidth - width - 8 > 0 else {
        let label = tagList.last?.subviews.first(where: { view in
          view is UILabel
        }) as? UILabel

        label?.attributedText = "+\(tags.count - tagList.count + 1)".styled(
          font: .captionRegular,
          color: .staticBlack
        )
        label?.sizeToFit()

        return
      }

      remainWidth = remainWidth - width - 8

      let container = UIView().then {
        $0.layer.cornerRadius = 14
        $0.backgroundColor = .gray300
        $0.clipsToBounds = true
      }

      container.addSubview(label)
      label.snp.makeConstraints {
        $0.top.bottom.equalToSuperview().inset(4.0)
        $0.left.right.equalToSuperview().inset(8.0)
      }

      contentView.addSubview(container)

      if let view = tagList.last {
        if index < tags.count {
          container.snp.makeConstraints {
            $0.left.equalTo(view.snp.right).offset(8.0)
            $0.top.bottom.equalToSuperview()
            $0.height.equalTo(28.0)
          }
        } else {
          container.snp.makeConstraints {
            $0.left.equalTo(view.snp.right).offset(8.0)
            $0.right.top.bottom.equalToSuperview()
            $0.height.equalTo(28.0)
          }
        }
      } else {
        container.snp.makeConstraints {
          $0.edges.equalToSuperview()
        }
      }

      tagList.append(container)
    }
  }
}
