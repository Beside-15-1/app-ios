//
//  MyPageViewModel.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/20.
//

import Foundation

import RxSwift

protocol MyPageViewModelInput {}

protocol MyPageViewModelOutput {}


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
