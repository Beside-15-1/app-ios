//
//  HomeFeedSectionProvider.swift
//  Presentation
//
//  Created by 박천송 on 7/10/24.
//

import Foundation
import UIKit

import DesignSystem

final class HomeFeedSectionProvider: SectionProvider<HomeFeedModel.Section, HomeFeedModel.Item> {
  typealias Section = HomeFeedModel.Section
  typealias Item = HomeFeedModel.Item


  override func sectionLayout(
    index: Int,
    environment: NSCollectionLayoutEnvironment
  ) -> NSCollectionLayoutSection? {
    guard let sectionViewModel = sectionViewModels[safe: index] else {
      return nil
    }

    switch sectionViewModel.section.id {
    case .banner:
      return makeBannerSection()
    case .normal:
      return makeNormalSection()
    case .more:
      return makeMoreSection()
    }
  }

  private func makeBannerSection() -> NSCollectionLayoutSection {
    let totalWidth = UIScreen.main.bounds.width
    let itemWidth = totalWidth
    let itemHeight = itemWidth * 84 / 375

    let item = NSCollectionLayoutItem(layoutSize: .init(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(itemHeight)
    ))

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(itemHeight)
    )

    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: groupSize,
      subitem: item,
      count: 1
    )

    return NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 20.0
    }
  }

  private func makeNormalSection() -> NSCollectionLayoutSection {
    let totalWidth = UIScreen.main.bounds.width - 40
    let itemWidth = totalWidth
    let itemHeight = itemWidth * 162 / 335 + 114

    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1),
        heightDimension: .estimated(itemHeight)
      )
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(itemHeight)
    )

    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: groupSize,
      subitem: item,
      count: 1
    )

    return NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 20.0
    }
  }

  private func makeMoreSection() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1),
        heightDimension: .estimated(48)
      )
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(48)
    )

    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: groupSize,
      subitem: item,
      count: 1
    )

    return NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 20.0
    }
  }
}

extension Collection {
  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
  public subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
