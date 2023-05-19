//
//  MypageViewModel.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation

import RxSwift

// MARK: - MypageViewModelInput

protocol MypageViewModelInput {}

// MARK: - MypageViewModelOutput

protocol MypageViewModelOutput {}

// MARK: - MypageViewModel

final class MypageViewModel: MypageViewModelOutput {
  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: initializing

  init() {}

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Output
}

// MARK: MypageViewModelInput

extension MypageViewModel: MypageViewModelInput {}
