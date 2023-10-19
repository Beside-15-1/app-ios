import UIKit

import PanModal
import ReactorKit
import RxSwift

import DesignSystem
import Domain
import PBAnalyticsInterface
import PresentationInterface

final class CreateLinkViewController: UIViewController, StoryboardView {

  var disposeBag = DisposeBag()

  // MARK: UI

  private lazy var contentView = CreateLinkView()


  // MARK: Properties

  private let analytics: PBAnalytics
  private let selectFolderBuilder: SelectFolderBuildable
  private let tagAddBuilder: TagAddBuildable
  private let createFolderBuilder: CreateFolderBuildable

  weak var delegate: CreateLinkDelegate?


  // MARK: Initializing

  init(
    reactor: CreateLinkViewReactor,
    analytics: PBAnalytics,
    selectFolderBuilder: SelectFolderBuildable,
    tagAddBuilder: TagAddBuildable,
    createFolderBuilder: CreateFolderBuildable
  ) {
    defer { self.reactor = reactor }
    self.analytics = analytics
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
    reactor?.action.onNext(.viewDidLoad)

    if let _ = reactor?.currentState.link {
      contentView.linkInputField.isEnabled = false
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    reactor?.action.onNext(.viewDidAppear)
  }

  // MARK: Binding

  func bind(reactor: CreateLinkViewReactor) {
    bindButtons(with: reactor)
    bindContent(with: reactor)
    bindTextField(with: reactor)
    bindRoute(with: reactor)
  }

  private func bindButtons(with reactor: CreateLinkViewReactor) {
    contentView.closeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        if reactor.currentState.isEdit {
          self.analytics.log(type: EditLinkEvent.click(component: .close))
        } else {
          self.analytics.log(type: AddLinkEvent.click(component: .close))
        }

        self.dismiss(animated: true)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.isSaveButtonEnabled)
      .distinctUntilChanged()
      .asObservable()
      .bind(to: contentView.saveButton.rx.isEnabled)
      .disposed(by: disposeBag)

    contentView.selectFolderView.container.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in

        if reactor.currentState.isEdit {
          self.analytics.log(type: EditLinkEvent.click(component: .selectFolder))
        } else {
          self.analytics.log(type: AddLinkEvent.click(component: .selectFolder))
        }

        guard let vc = self.selectFolderBuilder.build(
          payload: .init(
            folders: reactor.currentState.folderList,
            selectedFolder: reactor.currentState.folder,
            delegate: self
          )
        ) as? PanModalPresentable.LayoutType else { return }

        self.contentView.selectFolderView.select()
        if UIDevice.current.userInterfaceIdiom == .pad {
          self.presentPaperSheet(vc)
        } else {
          self.presentModal(vc)
        }
      }
      .disposed(by: disposeBag)

    contentView.tagView.addTagButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let reactor = self.reactor else { return }

        if reactor.currentState.isEdit {
          self.analytics.log(type: EditLinkEvent.click(component: .addTag))
        } else {
          self.analytics.log(type: AddLinkEvent.click(component: .addTag))
        }

        let vc = self.tagAddBuilder.build(
          payload: .init(
            tagAddDelegate: self,
            addedTagList: reactor.currentState.tags
          )
        )

        self.presentPaperSheet(vc)
      }
      .disposed(by: disposeBag)

    contentView.selectFolderView.createFolderButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in

        if reactor.currentState.isEdit {
          self.analytics.log(type: EditLinkEvent.click(component: .addFolder))
        } else {
          self.analytics.log(type: AddLinkEvent.click(component: .addFolder))
        }

        let vc = self.createFolderBuilder.build(payload: .init(
          folder: nil,
          delegate: self
        ))

        self.presentPaperSheet(vc)
      }
      .disposed(by: disposeBag)

    contentView.saveButton.rx.controlEvent(.touchUpInside)
      .map { Reactor.Action.saveButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindContent(with reactor: CreateLinkViewReactor) {
    reactor.state.compactMap(\.link)
      .distinctUntilChanged()
      .asObservable()
      .subscribe(with :self) { `self`, link in
        self.contentView.titleLabel.attributedText = "링크 수정".styled(font: .defaultRegular, color: .white)
      }
      .disposed(by: disposeBag)

    reactor.state.compactMap(\.thumbnail)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, thumbnail in
        self.contentView.linkInputField.text = thumbnail.url ?? ""
        self.contentView.titleInputField.text = thumbnail.title
        self.contentView.linkInputField.hideError()
        self.contentView.titleInputField.hideError()
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$linkError)
      .compactMap { $0 }
      .subscribe(with: self) { `self`, errorDescription in
        self.contentView.linkInputField.errorDescription = errorDescription
        self.contentView.linkInputField.showError()
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$titleError)
      .subscribe(with: self) { `self`, errorDescription in
        guard let errorDescription,
              let _ = reactor.currentState.thumbnail else {
          self.contentView.titleInputField.hideError()
          return
        }

        self.contentView.titleInputField.errorDescription = errorDescription
        self.contentView.titleInputField.showError()
      }
      .disposed(by: disposeBag)

    reactor.state.compactMap(\.folder)
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

    reactor.state.map(\.isLoading)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, isLoading in
        if isLoading {
          self.contentView.startLoading()
        } else {
          self.contentView.stopLoading()
        }
      }
      .disposed(by: disposeBag)
  }

  private func bindTextField(with reactor: CreateLinkViewReactor) {
    contentView.linkInputField.rx.text
      .map { Reactor.Action.inputURL($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    contentView.titleInputField.rx.text
      .map { Reactor.Action.updateTitle($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindRoute(with reactor: CreateLinkViewReactor) {
    reactor.state.compactMap(\.isSucceed)
      .distinctUntilChanged()
      .asObservable()
      .subscribe(with: self) { `self`, link in
        self.dismiss(animated: true) {
          self.delegate?.createLinkSucceed(link: link)
        }
      }
      .disposed(by: disposeBag)
  }
}


extension CreateLinkViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField.tag {
    case 1:
      guard let text = textField.text else { return true }

      if reactor?.currentState.isEdit == true {
        self.analytics.log(type: EditLinkEvent.click(component: .urlDone))
      } else {
        self.analytics.log(type: AddLinkEvent.click(component: .urlDone))
      }


      guard text.lowercased().hasPrefix("https://") || text.lowercased().hasPrefix("http://") else {
        let newText = "https://\(text)"
        view.endEditing(true)
        reactor?.action.onNext(.fetchThumbnail(newText))
        return true
      }

      view.endEditing(true)
      reactor?.action.onNext(.fetchThumbnail(text))
      return true

    case 2:
      if reactor?.currentState.isEdit == true {
        self.analytics.log(type: EditLinkEvent.click(component: .titleDone))
      } else {
        self.analytics.log(type: AddLinkEvent.click(component: .titleDone))
      }
      view.endEditing(true)
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

    if reactor.currentState.isEdit {
      self.analytics.log(type: EditLinkEvent.click(component: .deleteTag))
    } else {
      self.analytics.log(type: AddLinkEvent.click(component: .deleteTag))
    }

    var tags = reactor.currentState.tags
    tags.remove(at: at)
    reactor.action.onNext(.updateTag(tags))
  }
}


// MARK: CreateFolderDelegate

extension CreateLinkViewController: CreateFolderDelegate {
  func createFolderSucceed(folder: Folder) {
    reactor?.action.onNext(.createFolderSucceed(folder))
  }
}
