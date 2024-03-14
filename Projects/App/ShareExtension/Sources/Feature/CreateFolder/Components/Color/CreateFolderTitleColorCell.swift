//
//  CreateFolderTitleColorCell.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/04.
//

import Foundation
import UIKit

import DesignSystem

class CreateFolderTitleColorCell: UICollectionViewCell {

  static let identifier = "CreateFolderTitleColorCell"

  override var isSelected: Bool {
    didSet {
      checkImage.isHidden = !isSelected
    }
  }

  let checkImage = UIImageView().then {
    $0.image = DesignSystemAsset.iconCheck.image.withTintColor(.white)
    $0.isHidden = true
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(checkImage)

    checkImage.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(24.0)
    }
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

}

