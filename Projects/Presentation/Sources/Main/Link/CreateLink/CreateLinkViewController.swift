import UIKit

import ReactorKit
import RxSwift
import Toaster
import PanModal

import PresentationInterface
import Domain

final class CreateLinkViewController: UIViewController, StoryboardView {

  var disposeBag = DisposeBag()

  // MARK: UI

  private lazy var contentView = CreateLinkView()


  // MARK: Properties

  private let selectFolderBuilder: SelectFolderBuildable
  private let tagAddBuilder: TagAddBuildable
  private let createFolderBuilder: CreateFolderBuildable


  // MARK: Initializing

  init(
    reactor: CreateLinkViewReactor,
    selectFolderBuilder: SelectFolderBuildable,
    tagAddBuilder: TagAddBuildable,
    createFolderBuilder: CreateFolderBuildable
  ) {
    defer { self.reactor = reactor }
    self.selectFolderBuilder = selectFolderBuilder
    self.tagAddBuilder = tagAddBuilder
    self.createFolderBuilder = createFolderBuilder
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
    contentView.titleInputField.setDelegate(self)
    contentView.tagView.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: Binding

  func bind(reactor: CreateLinkViewReactor) {
    bindButtons(with: reactor)
    bindContent(with: reactor)
    bindTextField(with: reactor)
  }

  private func bindButtons(with reactor: CreateLinkViewReactor) {
    contentView.closeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.isSaveButtonEnabled)
      .distinctUntilChanged()
      .asObservable()
      .bind(to: contentView.saveButton.rx.isEnabled)
      .disposed(by: disposeBag
      )

    contentView.selectFolderView.container.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let vc = self.selectFolderBuilder.build(
          payload: .init(
            folders: [
              .init(),
              .init(title: "기획", backgroundColor: "as", titleColor: "asd", illustration: "df"),
              .init(title: "개발", backgroundColor: "as", titleColor: "asd", illustration: "fd"),
              .init(title: "디자인", backgroundColor: "as", titleColor: "asd", illustration: "df"),
              .init(title: "주섬", backgroundColor: "as", titleColor: "asd", illustration: "df"),
              .init(title: "집에", backgroundColor: "as", titleColor: "asd", illustration: "df"),
              .init(title: "가고싶다", backgroundColor: "as", titleColor: "asd", illustration: "df"),
            ],
            selectedFolder: self.reactor?.currentState.folder ?? .init(),
            delegate: self
          )
        ) as? PanModalPresentable.LayoutType else { return }

        self.contentView.selectFolderView.select()
        self.presentPanModal(vc)
      }
      .disposed(by: disposeBag)

    contentView.tagView.addTagButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let reactor = self.reactor else { return }
        let vc = self.tagAddBuilder.build(payload: .init(
          tagAddDelegate: self,
          addedTagList: reactor.currentState.tags)
        )

        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
      }
      .disposed(by: disposeBag)

    contentView.selectFolderView.createFolderButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        let vc = self.createFolderBuilder.build(payload: .init())

        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
      }
      .disposed(by: disposeBag)
  }

  private func bindContent(with reactor: CreateLinkViewReactor) {
    reactor.state.compactMap(\.thumbnail)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, thumbnail in
        self.contentView.titleInputField.text = thumbnail.title
        self.contentView.linkInputField.hideError()
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$linkError)
      .compactMap { $0 }
      .subscribe(with: self) { `self`, errorDescription in
        self.contentView.linkInputField.errorDescription = errorDescription
        self.contentView.linkInputField.showError()
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.folder)
      .distinctUntilChanged()
      .asObservable()
      .subscribe(with: self) { `self`, folder in
        self.contentView.selectFolderView.configure(withFolder: folder)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.tags)
      .distinctUntilChanged()
      .asObservable()
      .subscribe(with: self) { `self`, tags in
        self.contentView.tagView.applyAddedTag(by: tags)
      }
      .disposed(by: disposeBag)
  }

  private func bindTextField(with reactor: CreateLinkViewReactor) {
    contentView.titleInputField.rx.text
      .map { Reactor.Action.updateTitle($0) }
      .bind(to: reactor.action)
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
      self.view.endEditing(true)
      return true

    default:
      return false
    }
  }
}


// MARK: SelectFolderDelegate

extension CreateLinkViewController: SelectFolderDelegate {
  func selectFolderViewItemTapped(folder: Folder) {
    reactor?.action.onNext(.updateFolder(folder))
  }

  func selectFolderViewControllerDismissed() {
    contentView.selectFolderView.deselect()
  }
}


// MARK: AddTagDelegate

extension CreateLinkViewController: TagAddDelegate {
  func tagAddViewControllerMakeButtonTapped(tagList: [String]) {
    reactor?.action.onNext(.updateTag(tagList))
  }
}


// MARK: TagViewDelegate

extension CreateLinkViewController: TagViewDelegate {
  func removeAddedTag(at: Int) {
    guard let reactor else { return }

    var tags = reactor.currentState.tags
    tags.remove(at: at)
    reactor.action.onNext(.updateTag(tags))
  }
}
