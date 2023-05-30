//
//  FolderViewModel.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation

import RxSwift

// MARK: - FolderViewModelInput

protocol FolderViewModelInput {}

// MARK: - FolderViewModelOutput

protocol FolderViewModelOutput {}

// MARK: - FolderViewModel

final class FolderViewModel: FolderViewModelOutput {
  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: initializing

  init() {}

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Output
}

// MARK: FolderViewModelInput

extension FolderViewModel: FolderViewModelInput {}
