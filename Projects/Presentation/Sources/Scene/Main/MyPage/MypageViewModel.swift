//
//  MyPageViewModel.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation

import RxSwift

// MARK: - MyPageViewModelInput

protocol MyPageViewModelInput {}

// MARK: - MyPageViewModelOutput

protocol MyPageViewModelOutput {}

// MARK: - MyPageViewModel

final class MyPageViewModel: MyPageViewModelOutput {
  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: initializing

  init() {}

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Output
}

// MARK: MyPageViewModelInput

extension MyPageViewModel: MyPageViewModelInput {}
