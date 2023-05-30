//
//  HomeViewModel.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation

import RxSwift

// MARK: - HomeViewModelInput

protocol HomeViewModelInput {}

// MARK: - HomeViewModelOutput

protocol HomeViewModelOutput {}

// MARK: - HomeViewModel

final class HomeViewModel: HomeViewModelOutput {
  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: initializing

  init() {}

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Output
}

// MARK: HomeViewModelInput

extension HomeViewModel: HomeViewModelInput {}
