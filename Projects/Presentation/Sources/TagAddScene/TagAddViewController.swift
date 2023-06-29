import UIKit

import PanModal
import RxSwift

import PresentationInterface

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

    contentView.inputField.setDelegate(self)
    contentView.addedTagView.delegate = self
    contentView.tagListView.delegate = self
    contentView.tagListView.editHandler = { [weak self] text in
      self?.contentView.inputField.becomeFirstResponder()
      self?.viewModel.changeEditMode(text: text)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    bind(with: viewModel)
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
      }
      .disposed(by: disposeBag)

    viewModel.localTagList
      .delay(.milliseconds(100), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] local in
        guard !local.isEmpty else { return }
        self?.contentView.tagListView.applyTagList(by: local, selected: viewModel.addedTagList.value)
      })
      .disposed(by: disposeBag)

    contentView.inputField.rx.text
      .subscribe(with: self) { `self`, text in
        self.viewModel.inputText(text: text)
      }
      .disposed(by: disposeBag)

    viewModel.validatedText
      .bind(to: contentView.inputField.rx.text)
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
}

// MARK: AddedTagViewDelegate

extension TagAddViewController: AddedTagViewDelegate {
  func removeAddedTag(at row: Int) {
    let deletedTag = viewModel.addedTagList.value[row]

    viewModel.removeAddedTag(at: row)
    guard let index = viewModel.localTagList.value.firstIndex(of: deletedTag),
          let cell = contentView.tagListView.tableView
          .cellForRow(at: IndexPath(item: index, section: 0)) as? TagListCell
    else { return }

    cell.configureSelected(isSelected: false)
  }
}

// MARK: TagListViewDelegate

extension TagAddViewController: TagListViewDelegate {
  func tagListView(_ tagListView: TagListView, didSelectedRow at: Int) {
    guard let cell = tagListView.tableView.cellForRow(at: IndexPath(row: at, section: 0))
      as? TagListCell else { return }

    let selectedTag = viewModel.localTagList.value[at]

    if let index = viewModel.addedTagList.value.firstIndex(of: selectedTag) {
      // 해제
      viewModel.removeAddedTag(at: index)
      cell.configureSelected(isSelected: false)
    } else {
      // 선택
      viewModel.addTag(text: selectedTag)
    }
  }

  func updateTagList(_ tagListView: TagListView, tagList: [String]) {
    viewModel.localTagList.accept(tagList)
  }

  func removeTag(_ tagListView: TagListView, row at: Int) {
    viewModel.removeTagListTag(at: at)
  }
}
