import UIKit

import PanModal
import RxSwift

import PresentationInterface
import DesignSystem

// MARK: - TagAddViewController

final class TagAddViewController: UIViewController {
  // MARK: UI

  private lazy var contentView = TagAddView()

  // MARK: Properties

  private let viewModel: TagAddViewModel
  private let disposeBag = DisposeBag()

  weak var delegate: TagAddDelegate?

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

    contentView.addedTagView.delegate = self
    contentView.inputField.setDelegate(self)
    contentView.tagListView.delegate = self
    contentView.tagListView.editHandler = { [weak self] text in
      self?.contentView.inputField.becomeFirstResponder()
      self?.viewModel.changeEditMode(text: text)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    bind(with: viewModel)

    contentView.inputField.addTarget(
      self,
      action: #selector(textDidChange),
      for: .editingChanged
    )
  }

  // MARK: Binding

  func bind(with viewModel: TagAddViewModel) {
    bindContent(with: viewModel)
    bindButton(with: viewModel)
  }

  private func bindContent(with viewModel: TagAddViewModel) {
    viewModel.addedTagList
      .subscribe(with: self) { `self`, list in
        self.contentView.addedTagView.applyAddedTag(by: list)
        self.contentView.addedTagView.configureTagCount(count: list.count)
      }
      .disposed(by: disposeBag)

    viewModel.localTagList
      .delay(.milliseconds(100), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] local in
        guard !local.isEmpty else { return }
        self?.contentView.tagListView.applyTagList(by: local)
      })
      .disposed(by: disposeBag)

    viewModel.shouldShowTagLimitToast
      .subscribe(with: self) { _, _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          PBToast(content: "태그는 10개까지 선택할 수 있어요")
            .show()
        }
      }
      .disposed(by: disposeBag)

    viewModel.tagListIndexToScroll
      .subscribe(with: self) { `self`, row in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          self.contentView.addedTagView.collectionView
            .scrollToItem(
              at: IndexPath(item: row, section: 0),
              at: .centeredHorizontally,
              animated: true
            )
        }
      }
      .disposed(by: disposeBag)
  }

  private func bindButton(with viewModel: TagAddViewModel) {
    contentView.makeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true) {
          self.delegate?.tagAddViewControllerMakeButtonTapped(
            tagList: self.viewModel.addedTagList.value
          )
        }
      }
      .disposed(by: disposeBag)

    contentView.titleView.closeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true)
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
    false
  }

  var panModalBackgroundColor: UIColor {
    .black.withAlphaComponent(0.6)
  }

  var allowsDragToDismiss: Bool {
    false
  }

  func shouldRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
    return false
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
    textField.text = ""

    if viewModel.tagInputMode == .input {
      viewModel.addTag(text: text)
    } else {
      viewModel.editTag(text: text)
    }

    return true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    viewModel.editedTag = nil
    viewModel.tagInputMode = .input
  }

  @objc
  private func textDidChange(_ textField: UITextField) {
    if let text = textField.text {
      // 초과되는 텍스트 제거
      if text.count > 10 {
        DispatchQueue.main.async {
          textField.text = String(text.prefix(10))
        }
      }
    }
  }
}

// MARK: AddedTagViewDelegate

extension TagAddViewController: AddedTagViewDelegate {
  func removeAddedTag(at row: Int) {
    viewModel.removeAddedTag(at: row)
  }
}

// MARK: TagListViewDelegate

extension TagAddViewController: TagListViewDelegate {
  func tagListView(_ tagListView: TagListView, didSelectedRow at: Int) {
    guard let cell = tagListView.tableView.cellForRow(at: IndexPath(row: at, section: 0))
      as? TagListCell else { return }

    let selectedTag = viewModel.localTagList.value[at]

    guard let index = viewModel.addedTagList.value.firstIndex(of: selectedTag) else {
      viewModel.addTag(text: selectedTag)
      return
    }
  }

  func updateTagList(_ tagListView: TagListView, tagList: [String]) {
    viewModel.localTagList.accept(tagList)
  }

  func removeTag(_ tagListView: TagListView, row at: Int) {
    viewModel.removeTagListTag(at: at)
  }
}
