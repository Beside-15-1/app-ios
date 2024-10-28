//
//  SectionProvider.swift
//  Presentation
//
//  Created by 박천송 on 7/10/24.
//

import UIKit

protocol ItemModelType: Hashable, Identifiable {

}

extension ItemModelType {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}

protocol SectionModelType: Hashable, Identifiable {

}

extension SectionModelType {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}

struct SectionViewModel<Section: SectionModelType, Item: ItemModelType>: Hashable {
  let section: Section
  var items: [Item]
}

class SectionProvider<Section: SectionModelType, Item: ItemModelType> {

  var sectionViewModels = [SectionViewModel<Section, Item>]()

  func updateSectionViewModels(_ sectionViewModels: [SectionViewModel<Section, Item>]) {
    self.sectionViewModels = sectionViewModels
  }

  @discardableResult
  func updateSection(_ sectionViewModel: SectionViewModel<Section, Item>) -> Bool {
    guard let index = self.sectionViewModels.firstIndex(where: { $0.section.id == sectionViewModel.section.id }) else {
      return false
    }

    self.sectionViewModels[index] = sectionViewModel

    return true
  }

  @discardableResult
  func updateItem(_ item: Item, at indexPath: IndexPath) -> Bool {
    guard self.isValidItemIndexPath(indexPath) else {
      return false
    }

    return self.updateItem(item, to: self.sectionViewModels[indexPath.section].section.id)
  }

  @discardableResult
  func updateItem(_ item: Item, to sectionID: Section.ID) -> Bool {
    guard let sectionIndex = self.sectionViewModels.firstIndex(where: { $0.section.id == sectionID }) else {
      return false
    }

    guard let itemIndex = self.sectionViewModels[sectionIndex].items.firstIndex(where: { $0.id == item.id }) else {
      return false
    }

    self.sectionViewModels[sectionIndex].items[itemIndex] = item

    return true
  }

  @discardableResult
  func updateItem(_ item: Item, to sectionID: Section.ID, where handler: (Item) -> Bool) -> Bool {
    guard let sectionIndex = self.sectionViewModels.firstIndex(where: { $0.section.id == sectionID }) else {
      return false
    }

    guard let index = self.sectionViewModels[sectionIndex].items.firstIndex(where: handler) else {
      return false
    }

    self.sectionViewModels[sectionIndex].items[index] = item

    return true
  }

  @discardableResult
  func appendSection(_ sectionViewModel: SectionViewModel<Section, Item>) -> Bool {
    guard self.sectionViewModels.contains(where: { $0.section.id == sectionViewModel.section.id }) == false else {
      return false
    }

    self.sectionViewModels.append(sectionViewModel)

    return true
  }

  @discardableResult
  func appendItem(_ item: Item, at sectionIndex: Int) -> Bool {
    guard self.isValidSectionIndex(sectionIndex) else {
      return false
    }

    guard self.sectionViewModels[sectionIndex].items.contains(where: { $0.id == item.id }) == false else {
      return false
    }

    self.sectionViewModels[sectionIndex].items.append(item)

    return true
  }

  @discardableResult
  func appendItem(_ item: Item, to sectionID: Section.ID) -> Bool {
    guard let sectionIndex = self.sectionViewModels.firstIndex(where: { $0.section.id == sectionID }) else {
      return false
    }

    return self.appendItem(item, at: sectionIndex)
  }

  @discardableResult
  func removeSection(_ sectionID: Section.ID) -> Bool {
    guard let sectionIndex = self.sectionViewModels.firstIndex(where: { $0.section.id == sectionID }) else {
      return false
    }

    self.sectionViewModels.remove(at: sectionIndex)

    return true
  }

  @discardableResult
  func removeItem(_ item: Item, at sectionIndex: Int) -> Bool {
    guard self.isValidSectionIndex(sectionIndex) else {
      return false
    }

    return self.removeItem(item, in: self.sectionViewModels[sectionIndex].section.id)
  }

  @discardableResult
  func removeItem(_ item: Item, in sectionID: Section.ID) -> Bool {
    guard let sectionIndex = self.sectionViewModels.firstIndex(where: { $0.section.id == sectionID }) else {
      return false
    }

    guard let itemIndex = self.sectionViewModels[sectionIndex].items.firstIndex(where: { $0.id == item.id }) else {
      return false
    }

    self.sectionViewModels[sectionIndex].items.remove(at: itemIndex)

    return true
  }

  func numberOfSections() -> Int {
    return self.sectionViewModels.count
  }

  func numberOfItems(at sectionIndex: Int) -> Int {
    guard self.isValidSectionIndex(sectionIndex) else {
      return 0
    }

    return self.sectionViewModels[sectionIndex].items.count
  }

  func snapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

    snapshot.appendSections(sectionViewModels.map { $0.section })
    self.sectionViewModels.forEach { sectionViewModel in
      snapshot.appendItems(sectionViewModel.items, toSection: sectionViewModel.section)
    }

    return snapshot
  }

  func sectionLayout(
    index: Int,
    environment: NSCollectionLayoutEnvironment
  ) -> NSCollectionLayoutSection? {
    assertionFailure("This method should be overridden by the subclass")
    return nil
  }

  private func isValidSectionIndex(_ index: Int) -> Bool {
    return 0 <= index && index < self.sectionViewModels.count
  }

  private func isValidItemIndexPath(_ indexPath: IndexPath) -> Bool {
    guard self.isValidSectionIndex(indexPath.section) else {
      return false
    }

    return 0 <= indexPath.row && indexPath.row < sectionViewModels[indexPath.section].items.count
  }
}

