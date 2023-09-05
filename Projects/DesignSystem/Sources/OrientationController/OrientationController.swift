//
//  OrientationController.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/09/01.
//

import Foundation
import UIKit

public protocol OrientationDelegate: AnyObject {
  func didChangeOrientation(orientation: UIDeviceOrientation)
}

public class OrientationController {

  // MARK: Properties

  public weak var delegate: OrientationDelegate?
  private let notificationCenter = NotificationCenter.default


  // MARK: Initialize

  public init() {}

  deinit {}

  public func register(delegate: OrientationDelegate) {
    self.delegate = delegate

    notificationCenter.addObserver(
      self,
      selector: #selector(orientationDidChange),
      name: UIDevice.orientationDidChangeNotification,
      object: nil
    )
  }

  @objc
  private func orientationDidChange() {
    let orientation = UIDevice.current.orientation
    delegate?.didChangeOrientation(orientation: orientation)
  }
}
