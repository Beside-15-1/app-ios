import UIKit

import PanModal
import RxCocoa
import RxSwift

// MARK: - TermsOfUseViewController

final class TermsOfUseViewController: UIViewController {
  // MARK: UI

  private lazy var contentView = TermsOfUseView()

  // MARK: Properties

  private let viewModel: TermsOfUseViewModel
  private let disposeBag = DisposeBag()

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

  func bind(with viewModel: TermsOfUseViewModel) {
    bindButtons(with: viewModel)
  }

  private func bindButtons(with viewModel: TermsOfUseViewModel) {
    contentView.checkAllButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.viewModel.allCheckButtonTapped()
      }
      .disposed(by: disposeBag)

    contentView.checkServiceButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.viewModel.serviceCheckButtonTapped()
      }
      .disposed(by: disposeBag)

    contentView.checkPersonalButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.viewModel.personalCheckButtonTapped()
      }
      .disposed(by: disposeBag)

    viewModel.isAllSelected
      .bind(to: contentView.checkAllButton.rx.isSelected)
      .disposed(by: disposeBag)

    viewModel.isAllSelected
      .bind(to: contentView.nextButton.rx.isEnabled)
      .disposed(by: disposeBag)

    viewModel.isServiceSelected
      .bind(to: contentView.checkServiceButton.rx.isSelected)
      .disposed(by: disposeBag)

    viewModel.isPersonalSelected
      .bind(to: contentView.checkPersonalButton.rx.isSelected)
      .disposed(by: disposeBag)
  }
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
