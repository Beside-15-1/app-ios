//___FILEHEADER___

import UIKit

import ReactorKit
import RxSwift


final class ___VARIABLE_sceneName___ViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = ___VARIABLE_sceneName___View()


  // MARK: Properties

  var disposeBag = DisposeBag()


  // MARK: Initializing

  init(reactor: ___VARIABLE_sceneName___ViewReactor) {
    defer { self.reactor = reactor }
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
  }


  // MARK: Binding

  func bind(reactor: ___VARIABLE_sceneName___ViewReactor) {}
}
