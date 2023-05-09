//___FILEHEADER___

import Foundation

import RxSwift

protocol ___VARIABLE_sceneName___ViewModelInput {}

protocol ___VARIABLE_sceneName___ViewModelOutput {}


final class ___VARIABLE_sceneName___ViewModel: ___VARIABLE_sceneName___ViewModelOutput {

  // MARK: Properties

  private let disposeBag = DisposeBag()


  // MARK: initializing

  init() {}

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Output
}


// MARK: ___VARIABLE_sceneName___ViewModelInput

extension ___VARIABLE_sceneName___ViewModel: ___VARIABLE_sceneName___ViewModelInput {}
