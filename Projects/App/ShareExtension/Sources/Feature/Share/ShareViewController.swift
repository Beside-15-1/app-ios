//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by 박천송 on 2023/08/17.
//

import UIKit

import ReactorKit
import RxSwift

import KeychainAccess

final class ShareViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = ShareView()


  // MARK: Properties

  var disposeBag = DisposeBag()


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
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let _ = Keychain(service: "com.pinkboss.joosum")["accessToken"] else {
      reactor?.action.onNext(.viewDidLoad)
      return
    }

    getURL { [weak self] url in
      self?.reactor?.action.onNext(.fetchThumbnaiil(url))
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
  }
}


// MARK: Share

extension ShareViewController {

  private func getURL(handleURL: ((URL) -> Void)?) {
    // Get the extension context
    if let inputItems = extensionContext?.inputItems as? [NSExtensionItem] {
      // Loop through the input items
      for item in inputItems {
        // Check if there are attachments
        if let attachments = item.attachments {
          // Loop through the attachments
          for attachment in attachments {
            // Check if the attachment contains a URL
            if attachment.hasItemConformingToTypeIdentifier("public.url") {
              attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { url, error in
                if let url = url as? URL {
                  // Handle the URL
                  handleURL?(url)
                }
              }
            }
          }
        }
      }
    }
  }
}
