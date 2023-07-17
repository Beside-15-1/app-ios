//
//  PBToast.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/07/17.
//

import Foundation

import Toaster

public class PBToast {

  private let toast: Toast

  public init(
    content: String
  ) {
    toast = Toast(
      attributedText: content.styled(
        font: .subTitleSemiBold,
        color: .white
      )
    )
  }

  public func show() {
    toast.show()
  }
}
