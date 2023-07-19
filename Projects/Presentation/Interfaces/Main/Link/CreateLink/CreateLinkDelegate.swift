//
//  CreateLinkDelegate.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/07/11.
//

import Foundation

import Domain

public protocol CreateLinkDelegate: AnyObject {
  func createLinkSucceed(link: Link)
}
