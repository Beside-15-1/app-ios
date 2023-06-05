import UIKit

import RxSwift

final class HomeViewController: UIViewController {
  // MARK: UI

  private lazy var contentView = HomeView()

  // MARK: Properties

  private let viewModel: HomeViewModel

  // MARK: Initializing

  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
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

    bind(with: viewModel)
  }

  // MARK: Binding

  func bind(with viewModel: HomeViewModel) {}
}
