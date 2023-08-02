import UIKit

import PanModal
import RxCocoa
import RxSwift

import PresentationInterface

// MARK: - TermsOfUseViewController

final class TermsOfUseViewController: UIViewController {
  // MARK: UI

  private lazy var contentView = TermsOfUseView()

  // MARK: Properties

  private let viewModel: TermsOfUseViewModel
  private let disposeBag = DisposeBag()

  weak var delegate: TermsOfUseDelegate?

  private let webBuilder: PBWebBuildable

  // MARK: Initializing

  init(
    viewModel: TermsOfUseViewModel,
    webBuilder: PBWebBuildable
  ) {
    self.viewModel = viewModel

    self.webBuilder = webBuilder

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

    contentView.nextButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true) {
          self.delegate?.termsOfUseNextButtonTapped()
        }
      }
      .disposed(by: disposeBag)

    contentView.checkServiceButton.showPageButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let url = URL(string: "https://joosum.notion.site/6df241a6e3174b8fbfc7933a506a0b1e?pvs=4") else {
          return
        }

        let web = self.webBuilder.build(payload: .init(url: url)).then {
          if UIDevice.current.userInterfaceIdiom == .pad {
            $0.modalPresentationStyle = .overFullScreen
          } else {
            $0.modalPresentationStyle = .popover
          }
        }

        self.present(web, animated: true)
      }
      .disposed(by: disposeBag)

    contentView.checkPersonalButton.showPageButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let url = URL(string: "https://joosum.notion.site/33975a64eb55468ea523f707353743cf?pvs=4") else {
          return
        }

        let web = self.webBuilder.build(payload: .init(url: url)).then {
          if UIDevice.current.userInterfaceIdiom == .pad {
            $0.modalPresentationStyle = .overFullScreen
          } else {
            $0.modalPresentationStyle = .popover
          }
        }

        self.present(web, animated: true)
      }
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
    .modalBackgorund
  }

  var showDragIndicator: Bool {
    true
  }
}
