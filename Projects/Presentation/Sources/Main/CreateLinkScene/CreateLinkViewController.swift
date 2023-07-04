import UIKit

import ReactorKit
import RxSwift
import Toaster

final class CreateLinkViewController: UIViewController, StoryboardView {

  var disposeBag = DisposeBag()

  // MARK: UI

  private lazy var contentView = CreateLinkView()

  // MARK: Initializing

  init(viewModel: CreateLinkViewReactor) {
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

    contentView.linkInputField.setDelegate(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: Binding

  func bind(reactor: CreateLinkViewReactor) {
    bindButtons(with: reactor)
    bindContent(with: reactor)
  }

  private func bindButtons(with reactor: CreateLinkViewReactor) {
    contentView.closeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true)
      }
      .disposed(by: disposeBag)
  }

  private func bindContent(with reactor: CreateLinkViewReactor) {
    reactor.state.map(\.thumbnail)
      .subscribe(with: self) { `self`, thumbnail in
        self.contentView.titleInputField.text = thumbnail?.title
      }
      .disposed(by: disposeBag)
  }
}


extension CreateLinkViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField.tag {
    case 1:
      guard let text = textField.text else { return true }

      guard text.lowercased().hasPrefix("https://") || text.lowercased().hasPrefix("http://") else {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          Toast(
            attributedText: "올바른 링크를 입력해주세요".styled(
              font: .defaultRegular,
              color: .white
            ),
            duration: .init(3)
          )
          .show()
        }
        self.view.endEditing(true)
        return true
      }

      self.reactor?.action.onNext(.fetchThumbnail(text))
      self.view.endEditing(true)
      return true

    case 2:
      return true

    default:
      return false
    }
  }
}
