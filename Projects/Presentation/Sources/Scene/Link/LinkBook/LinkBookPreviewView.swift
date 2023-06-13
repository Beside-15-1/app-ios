//
//  LinkBookPreviewView.swift
//  PresentationInterface
//
//  Created by Hohyeon Moon on 2023/06/01.
//

import UIKit

class LinkBookPreviewView: UIView {
  private lazy var bookCover = {
    let view = UIView()
    view.layer.cornerRadius = 6
    view.backgroundColor = UIColor(hexString: "#FF6854")
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.5
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowRadius = 3
    return view
  }()

  private lazy var verticalBar = {
    let view = UIView()
    view.backgroundColor = .black.withAlphaComponent(0.1)
    return view
  }()

  private lazy var bookText = {
    let label = UILabel()
    label.text = "일이삼사오\n육칠팔구십"
    label.numberOfLines = 3
    label.textColor = .white
    label.font = .subTitleBold
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .gray400
    setView()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setView() {
    addSubview(bookCover)
    bookCover.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalTo(132)
      make.height.equalTo(179)
    }

    bookCover.addSubview(verticalBar)
    verticalBar.snp.makeConstraints { make in
      make.width.equalTo(2)
      make.left.equalToSuperview().offset(10)
      make.height.equalToSuperview()
      make.centerY.equalToSuperview()
    }

    bookCover.addSubview(bookText)
    bookText.snp.makeConstraints { make in
      make.left.equalTo(verticalBar.snp.right).offset(8)
      make.right.equalToSuperview().offset(-8)
      make.top.equalToSuperview().offset(20)
    }
  }
}
