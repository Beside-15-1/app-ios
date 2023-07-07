//
//  CreateFolderPreviewView.swift
//  PresentationInterface
//
//  Created by Hohyeon Moon on 2023/06/01.
//

import UIKit

import Domain

class CreateFolderPreviewView: UIView {

  struct ViewModel: Hashable {
    var backgroundColor: String
    var titleColor: String
    var title: String
    var illuste: String?
  }

  // MARK: UI

  private lazy var bookCover = {
    let view = UIView()
    view.layer.cornerRadius = 6
    view.backgroundColor = UIColor(hexString: "#91B0C4")
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
    label.text = "제목을 입력하세요"
    label.numberOfLines = 3
    label.textColor = .white
    label.font = .bodyBold
    return label
  }()

  // MARK: Life Cycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .paperGray
    setView()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configure(with folder: ViewModel) {
    bookCover.backgroundColor = UIColor(hexString: folder.backgroundColor)
    bookText.text = folder.title
    bookText.textColor = UIColor(hexString: folder.titleColor)
  }


  // MARK: Layout

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
