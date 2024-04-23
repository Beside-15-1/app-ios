//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by 박천송 on 2023/08/17.
//

import UIKit

import FirebaseAnalytics
import KeychainAccess
import ReactorKit
import RxKeyboard
import RxSwift

import Domain
import PBUserDefaults

final class ShareViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = ShareView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let analytics = PBAnalyticsImpl(firebaseAnalytics: FirebaseAnalytics.Analytics.self)

  // MARK: Initializing

  init() {
    defer { self.reactor = ShareViewReactor() }
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView

    contentView.boxView.titleInputField.setDelegate(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let _ = Keychain(service: "com.pinkboss.joosum")["accessToken"] else {
      reactor?.action.onNext(.viewDidLoad)
      return
    }

    reactor?.action.onNext(.viewDidLoad)
    getURL { [weak self] url in
      self?.reactor?.action.onNext(.fetchThumbnail(url))
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    if reactor?.currentState.status == .needLogin, let _ = Keychain(service: "com.pinkboss.joosum")["accessToken"] {
      getURL { [weak self] url in
        self?.reactor?.action.onNext(.fetchThumbnail(url))
      }
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    switch reactor?.currentState.status {
    case .needLogin:
      analytics.log(type: ShareLoginEvent.shown)
    default:
      analytics.log(type: ShareAddLinkEvent.shown)
    }
  }


  // MARK: Binding

  func bind(reactor: ShareViewReactor) {
    reactor.state.map(\.status)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, status in
        self.contentView.boxView.configure(status: status)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.link)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, link in
        self.contentView.boxView.configure(link: link)
      }
      .disposed(by: disposeBag)

    contentView.boxView.titleView.closeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        if reactor.currentState.status == .needLogin {
          self.analytics.log(type: ShareLoginEvent.click(component: .close))
        } else {
          self.analytics.log(type: ShareAddLinkEvent.click(component: .close))
        }

        self.extensionContext?.completeRequest(returningItems: nil)
      }
      .disposed(by: disposeBag)

    contentView.boxView.completeButton.rx.controlEvent(.touchUpInside)
      .withLatestFrom(reactor.state.map(\.status))
      .subscribe(with: self) { `self`, status in
        switch status {
        case .loading:
          break

        case .success:
          self.analytics.log(type: ShareAddLinkEvent.click(component: .selectFolder))
          reactor.action.onNext(.completeButtonTapped(self.contentView.boxView.titleInputField.text ?? ""))

        case .needLogin:
          self.analytics.log(type: ShareLoginEvent.click(component: .login))
          self.extensionContext?.completeRequest(returningItems: nil) { _ in
            let _ = self.openURL(URL(string: "joosum://")!)
          }

        case .failure:
          reactor.action.onNext(.retryFetchThumbnail)
        }
      }
      .disposed(by: disposeBag)

    contentView.boxView.selectFolderButton.container.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.analytics.log(type: ShareAddLinkEvent.click(component: .selectFolder))

        let vc = SelectFolderViewController(
          reactor: .init(
            folders: reactor.currentState.folderList, selectedFolder: reactor.currentState.folderList.first
          )
        ).then {
          $0.delegate = self
        }

        self.presentPaperSheet(vc)
      }
      .disposed(by: disposeBag)

    RxKeyboard.instance.visibleHeight
      .drive(with: self) { `self`, height in
        self.view.transform = CGAffineTransform(translationX: 0, y: -height)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.shouldDismiss)
      .filter { $0 }
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, _ in
        self.extensionContext?.completeRequest(returningItems: nil)
      }
      .disposed(by: disposeBag)

    contentView.boxView.addTagButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.analytics.log(type: ShareAddLinkEvent.click(component: .addTag))

        let vc = TagAddViewController(
          reactor: .init(
            addedTagList: reactor.currentState.link?.tags ?? []
          )
        ).then {
          $0.delegate = self
        }

        self.presentPaperSheet(vc)
      }
      .disposed(by: disposeBag)

    contentView.boxView.titleInputField.rx.editingDidBegin
      .subscribe(with: self) { `self`, _ in
        self.analytics.log(type: ShareAddLinkEvent.click(component: .titleInput))
      }
      .disposed(by: disposeBag)

    contentView.boxView.selectFolderButton.createFolderButton.rx.controlEvent(.touchUpInside)
      .subscribe(onNext: { [weak self] _ in
        guard let self else { return }

        let vc = CreateFolderViewController(
          reactor: .init()
        ).then {
          $0.delegate = self
        }

        self.presentPaperSheet(vc)
      })
      .disposed(by: disposeBag)
  }
}


// MARK: Share

extension ShareViewController {

  private func getURL(handleURL: ((URL) -> Void)?) {
    if let inputItems = extensionContext?.inputItems as? [NSExtensionItem] {
      for item in inputItems {
        if let attachments = item.attachments {
          for attachment in attachments {
            if attachment.hasItemConformingToTypeIdentifier("public.url") {
              attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { url, error in
                if let url = url as? URL {
                  handleURL?(url)
                }
              }
            }
          }
        }
      }
    }
  }

  @objc
  func openURL(_ url: URL) -> Bool {
    var responder: UIResponder? = self
    while responder != nil {
      if let application = responder as? UIApplication {
        return application.perform(#selector(openURL(_:)), with: url) != nil
      }
      responder = responder?.next
    }
    return false
  }
}


// MARK: SelectFolderDelegate

extension ShareViewController: SelectFolderDelegate {
  func selectFolderViewItemTapped(folder: Folder) {
    reactor?.action.onNext(.updateFolder(folder))
  }
}


// MARK: TextField

extension ShareViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let currentTitle = reactor?.currentState.link?.title ?? ""

    guard currentTitle != textField.text else {
      view.endEditing(true)
      return true
    }

    reactor?.action.onNext(.updateTitle(textField.text ?? ""))
    view.endEditing(true)
    return true
  }
}


// MARK: TagAddDelegate

extension ShareViewController: TagAddDelegate {
  func tagAddViewControllerMakeButtonTapped(tagList: [String]) {
    reactor?.action.onNext(.updateTags(tagList))
  }
}


// MARK: CreateFolderDelegate

extension ShareViewController: CreateFolderDelegate {
  func createFolderSucceed(folder: Folder) {
    reactor?.action.onNext(.updateFolder(folder))
  }
}
