//___FILEHEADER___

import UIKit

import RxSwift



final class ___VARIABLE_sceneName___ViewController: UIViewController {

  // MARK: UI

  private lazy var contentView = ___VARIABLE_sceneName___View()


  // MARK: Properties

  private let viewModel: ___VARIABLE_sceneName___ViewModel


  // MARK: Initializing

  init(viewModel: ___VARIABLE_sceneName___ViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    bind(with: viewModel)
  }


  // MARK: Binding

  func bind(with viewModel: ___VARIABLE_sceneName___ViewModel) {}
}
