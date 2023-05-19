//
//  EntryViewModel.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation

import RxSwift

// MARK: - EntryViewModelInput

protocol EntryViewModelInput {}

// MARK: - EntryViewModelOutput

protocol EntryViewModelOutput {}

// MARK: - EntryViewModel

final class EntryViewModel: EntryViewModelOutput {
  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: initializing

  init() {}

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Output
}

// MARK: EntryViewModelInput

extension EntryViewModel: EntryViewModelInput {}
