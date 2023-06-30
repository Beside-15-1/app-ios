import UIKit

import ReactorKit
import RxSwift

final class CreateLinkViewController: UIViewController, StoryboardView {
  typealias Reactor = CreateLinkViewModel

  var disposeBag = DisposeBag()

  // MARK: UI

  private lazy var contentView = CreateLinkView()

  // MARK: Initializing

  init(viewModel: CreateLinkViewModel) {
    defer { self.reactor = viewModel }
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
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

  func bind(reactor viewModel: CreateLinkViewModel) {}
}
