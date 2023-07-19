//
//  Thumbnail.swift
//  Domain
//
//  Created by 박천송 on 2023/07/04.
//

import Foundation
import UIKit

public struct Thumbnail: Hashable {
  public var title: String?
  public let url: String?
  public let imageURL: String?

  public init(title: String? = nil, url: String?, imageURL: String?) {
    self.title = title
    self.url = url
    self.imageURL = imageURL
  }
}
