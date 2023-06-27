import UIKit

import PanModal
import RxSwift

// MARK: - TagAddViewController

final class TagAddViewController: UIViewController {
  // MARK: UI

  private lazy var contentView = TagAddView()

  // MARK: Properties

  private let viewModel: TagAddViewModel
  private let disposeBag = DisposeBag()

  // MARK: Initializing

  init(viewModel: TagAddViewModel) {
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

    contentView.inputField.setDelegate(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    bind(with: viewModel)
  }

  // MARK: Binding

  func bind(with viewModel: TagAddViewModel) {
    bindContent(with: viewModel)
  }

  private func bindContent(with viewModel: TagAddViewModel) {
    viewModel.addedTagList
      .subscribe(with: self) { `self`, list in
        self.contentView.addedTagView.applyAddedTag(by: list)
      }
      .disposed(by: disposeBag)

    viewModel.localTagList
      .subscribe(with: self) { `self`, list in
        self.contentView.tagListView.applyTagList(by: list)
      }
      .disposed(by: disposeBag)
  }
}

// MARK: PanModalPresentable

extension TagAddViewController: PanModalPresentable {
  var panScrollable: UIScrollView? {
    contentView.tagListView.tableView
  }

  var shortFormHeight: PanModalHeight {
    .maxHeight
  }

  var longFormHeight: PanModalHeight {
    .maxHeight
  }

  var cornerRadius: CGFloat {
    16.0
  }

  var showDragIndicator: Bool {
    true
  }

  var panModalBackgroundColor: UIColor {
    .black.withAlphaComponent(0.6)
  }
}

// MARK: UITextFieldDelegate

extension TagAddViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text,
          !text.isEmpty else {
      view.endEditing(true)
      return false
    }

    view.endEditing(true)
    viewModel.addTag(text: text)
    return true
  }
}
