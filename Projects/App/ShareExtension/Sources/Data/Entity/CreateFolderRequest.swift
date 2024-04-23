//
//  CreateFolderRequest.swift
//  ShareExtension
//
//  Created by 박천송 on 3/20/24.
//  Copyright © 2024 PinkBoss Inc. All rights reserved.
//

import Foundation

struct CreateFolderRequest: Codable {
  let backgroundColor: String
  let illustration: String?
  let title: String
  let titleColor: String

  enum CodingKeys: CodingKey {
    case backgroundColor
    case illustration
    case title
    case titleColor
  }
}
