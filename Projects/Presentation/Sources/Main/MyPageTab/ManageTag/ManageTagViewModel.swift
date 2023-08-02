//
//  ManageTagViewModel.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import Foundation

import RxSwift

protocol ManageTagViewModelInput {}

protocol ManageTagViewModelOutput {}


final class ManageTagViewModel: ManageTagViewModelOutput {

  // MARK: Properties

  private let disposeBag = DisposeBag()


  // MARK: initializing

  init() {}

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Output
}


// MARK: ManageTagViewModelInput

extension ManageTagViewModel: ManageTagViewModelInput {}
