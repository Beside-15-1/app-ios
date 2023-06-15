import UIKit

import PanModal
import RxSwift

// MARK: - TermsOfUseViewController

final class TermsOfUseViewController: UIViewController {
  // MARK: UI

  private lazy var contentView = TermsOfUseView()

  // MARK: Properties

  private let viewModel: TermsOfUseViewModel

  // MARK: Initializing

  init(viewModel: TermsOfUseViewModel) {
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

  func bind(with viewModel: TermsOfUseViewModel) {}
}

// MARK: PanModalPresentable

extension TermsOfUseViewController: PanModalPresentable {
  var panScrollable: UIScrollView? {
    nil
  }

  var shortFormHeight: PanModalHeight {
    .contentHeight(336)
  }

  var longFormHeight: PanModalHeight {
    .contentHeight(336)
  }

  var cornerRadius: CGFloat {
    16.0
  }

  var panModalBackgroundColor: UIColor {
    .black.withAlphaComponent(0.6)
  }

  var showDragIndicator: Bool {
    false
  }
}
