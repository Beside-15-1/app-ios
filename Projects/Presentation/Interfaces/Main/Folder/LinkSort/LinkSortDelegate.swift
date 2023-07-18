//
//  LinkSortDelegate.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/18.
//

import Foundation

import Domain

public protocol LinkSortDelegate: AnyObject {
  func linkSortListItemTapped(type: LinkSortingType)
}
