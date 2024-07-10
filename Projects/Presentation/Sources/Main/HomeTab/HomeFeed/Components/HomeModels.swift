//
//  HomeFeedModels.swift
//  Presentation
//
//  Created by 박천송 on 6/21/24.
//

import Foundation

enum HomeFeedModel {
  struct Section: SectionModelType {
    enum ID: Hashable {
      case banner
      case normal
      case more
    }

    let id: ID
    let title: String?
  }

  enum Item: ItemModelType {
    typealias ID = String

    case banner(HomeBannerCell.ViewModel)
    case link(HomeFeedCell.ViewModel)
    case more(Int)

    var id: ID {
      switch self {
      case .banner:
        return "banner"
      case .link:
        return "link"
      case .more:
        return "more"
      }
    }
  }
}
