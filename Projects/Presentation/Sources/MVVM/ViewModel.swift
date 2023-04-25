//
//  ViewModel.swift
//  Presentation
//
//  Created by 박천송 on 2023/04/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol ViewModelInput {
  func plus()
  func minus()
}

protocol ViewModelOutput {
  var text: BehaviorRelay<String> { get }
}

class ViewModel: ViewModelOutput {

  var text: BehaviorRelay<String> = .init(value: "0")

}

extension ViewModel: ViewModelInput {
  func plus() {
    let number = Int(text.value) ?? 0

    text.accept(String(number + 1))
  }

  func minus() {
    let number = Int(text.value) ?? 0

    text.accept(String(number - 1))
  }
}
