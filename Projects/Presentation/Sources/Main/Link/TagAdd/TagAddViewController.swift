import UIKit

import PanModal
import ReactorKit
import RxSwift

import DesignSystem
import PBAnalyticsInterface
import PresentationInterface


final class TagAddViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = TagAddView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let analytics: PBAnalytics

  weak var delegate: TagAddDelegate?


  // MARK: Initializing

  init(
    reactor: TagAddReactor,
    analytics: PBAnalytics
  ) {
    defer { self.reactor = reactor }

    self.analytics = analytics

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
    contentView.tagListView.editHandler = { [weak self] tag in
      self?.contentView.inputField.becomeFirstResponder()
      self?.reactor?.action.onNext(.editButtonTapped(tag))
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    reactor?.action.onNext(.viewDidLoad)

    contentView.inputField.addTarget(
      self,
      action: #selector(textDidChange),
      for: .editingChanged
    )
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    reactor?.action.onNext(.viewDidAppear)
  }


  // MARK: Binding

  func bind(reactor: TagAddReactor) {
    bindContent(with: reactor)
    bindButton(with: reactor)
  }

  private func bindContent(with reactor: TagAddReactor) {
    reactor.state.map(\.addedTagList)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, list in
        self.contentView.addedTagView.applyAddedTag(by: list)
        self.contentView.addedTagView.configureTagCount(count: list.count)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.tagList)
      .distinctUntilChanged()
      .delay(.milliseconds(100), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] tagList in
        guard let self else { return }
        guard !tagList.isEmpty else { return }
        contentView.tagListView.applyTagList(by: tagList)
      })
      .disposed(by: disposeBag)

    reactor.pulse(\.$shouldShowTagLimitToast)
      .filter { $0 }
      .subscribe(with: self) { _, _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          PBToast(content: "태그는 10개까지 선택할 수 있어요")
            .show()
        }
      }
      .disposed(by: disposeBag)
  }

  private func bindButton(with reactor: TagAddReactor) {
    contentView.makeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.analytics.log(type: AddTagEvent.click(component: .saveTag))
        self.dismiss(animated: true) {
          self.delegate?.tagAddViewControllerMakeButtonTapped(
            tagList: reactor.currentState.addedTagList
          )
        }
      }
      .disposed(by: disposeBag)

    contentView.titleView.closeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.analytics.log(type: AddTagEvent.click(component: .close))
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
    false
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

    reactor?.action.onNext(.returnButtonTapped(text))

    return true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    reactor?.action.onNext(.endEditing)
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
    reactor?.action.onNext(.addedTagRemoveButtonTapped(at: row))
  }
}

// MARK: TagListViewDelegate

extension TagAddViewController: TagListViewDelegate {
  func tagListView(_ tagListView: TagListView, didSelectedRow at: Int) {
    reactor?.action.onNext(.selectTag(at: at))
  }

  func updateTagList(_ tagListView: TagListView, tagList: [String]) {
    reactor?.action.onNext(.replaceTagOrder(tagList))
  }

  func removeTag(_ tagListView: TagListView, row at: Int) {
    reactor?.action.onNext(.tagListTagRemoveButtonTapped(at: at))
  }
}
