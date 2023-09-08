//
//  MyFolderLayoutBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/09/05.
//

import Foundation
import UIKit

enum MyFolderLayoutType {
  case portraitNarrow
  case portraitWide
  case landscapeNarrow
  case landscapeWide
}

class MyFolderLayoutBuilder {

  func build(layout: MyFolderLayoutType) -> UICollectionViewLayout {

    if UIDevice.current.userInterfaceIdiom == .pad {
      switch layout {
      case .portraitNarrow:
        return portraitNarrowCollectionViewLayout()
      case .portraitWide:
        return portraitWideCollectionViewLayout()
      case .landscapeNarrow:
        return landscapeNarrowCollectionViewLayout()
      case .landscapeWide:
        return landscapeWideCollectionViewLayout()
      }
    }

    return iphoneCollectionViewLayout()
  }

  private func iphoneCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1/3),
        heightDimension: .fractionalWidth(1.6/3)
      )
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1.6/3)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 3
    ).then {
      $0.interItemSpacing = .fixed(8.5)
    }

    let section = NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 12.0
    }

    let configuration = UICollectionViewCompositionalLayoutConfiguration().then {
      $0.scrollDirection = .vertical
    }

    return UICollectionViewCompositionalLayout(
      section: section,
      configuration: configuration
    )
  }

  private func portraitNarrowCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1/4),
        heightDimension: .fractionalWidth(1.6/4)
      )
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1.6/4)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 4
    ).then {
      $0.interItemSpacing = .fixed(10.0)
    }

    let section = NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 20.0
    }

    let configuration = UICollectionViewCompositionalLayoutConfiguration().then {
      $0.scrollDirection = .vertical
    }

    return UICollectionViewCompositionalLayout(
      section: section,
      configuration: configuration
    )
  }

  private func portraitWideCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1/5),
        heightDimension: .fractionalWidth(1.6/5)
      )
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1.6/5)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 5
    ).then {
      $0.interItemSpacing = .fixed(30.0)
    }

    let section = NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 20.0
    }

    let configuration = UICollectionViewCompositionalLayoutConfiguration().then {
      $0.scrollDirection = .vertical
    }

    return UICollectionViewCompositionalLayout(
      section: section,
      configuration: configuration
    )
  }

  private func landscapeNarrowCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1/6),
        heightDimension: .fractionalWidth(1.6/6)
      )
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1.6/6)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 6
    ).then {
      $0.interItemSpacing = .fixed(16.0)
    }

    let section = NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 20.0
    }

    let configuration = UICollectionViewCompositionalLayoutConfiguration().then {
      $0.scrollDirection = .vertical
    }

    return UICollectionViewCompositionalLayout(
      section: section,
      configuration: configuration
    )
  }

  private func landscapeWideCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1/7),
        heightDimension: .fractionalWidth(1.6/7)
      )
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1.6/7)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 7
    ).then {
      $0.interItemSpacing = .fixed(20.0)
    }

    let section = NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 20.0
    }

    let configuration = UICollectionViewCompositionalLayoutConfiguration().then {
      $0.scrollDirection = .vertical
    }

    return UICollectionViewCompositionalLayout(
      section: section,
      configuration: configuration
    )
  }

}
