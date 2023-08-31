//
//  LinkDetailViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/18.
//

import UIKit

import PanModal
import ReactorKit
import RxSwift

import DesignSystem
import Domain
import PresentationInterface

final class LinkDetailViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = LinkDetailView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let createLinkBuilder: CreateLinkBuildable
  private let moveFolderBuilder: MoveFolderBuildable
  private let webBuilder: PBWebBuildable

  // MARK: Initializing

  init(
    reactor: LinkDetailViewReactor,
    createLinkBuilder: CreateLinkBuildable,
    moveFolderBuilder: MoveFolderBuildable,
    webBuilder: PBWebBuildable
  ) {
    defer { self.reactor = reactor }

    self.createLinkBuilder = createLinkBuilder
    self.moveFolderBuilder = moveFolderBuilder
    self.webBuilder = webBuilder

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
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.isNavigationBarHidden = false

    configureNavigationBar()
  }


  // MARK: Binding

  func bind(reactor: LinkDetailViewReactor) {
    bindContent(with: reactor)
    bindButton(with: reactor)
    bindRoute(with: reactor)
  }

  private func bindContent(with reactor: LinkDetailViewReactor) {
    reactor.state.map(\.link)
      .asObservable()
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, link in
        self.contentView.configure(withLink: link)
      }
      .disposed(by: disposeBag)
  }

  private func bindButton(with reactor: LinkDetailViewReactor) {
    contentView.bottomView.deleteButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        PBDialog(
          title: "링크를 삭제하시겠어요?",
          content: "삭제한 링크는 다시 되돌릴 수 없어요",
          from: self
        )
        .addAction(content: "취소", priority: .secondary, action: nil)
        .addAction(content: "삭제", priority: .primary, action: {
          reactor.action.onNext(.deleteButtonTapped)
        })
        .show()
      }
      .disposed(by: disposeBag)

    contentView.bottomView.editButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        let createLink = self.createLinkBuilder.build(
          payload: .init(
            delegate: self,
            link: reactor.currentState.link
          )
        )

        self.presentFormSheet(createLink)
      }
      .disposed(by: disposeBag)

    contentView.bottomView.moveButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let moveFolder = self.moveFolderBuilder.build(
          payload: .init(
            delegate: self,
            folderID: reactor.currentState.link.linkBookId
          )
        ) as? PanModalPresentable.LayoutType else { return }

        if UIDevice.current.userInterfaceIdiom == .pad {
          moveFolder.modalPresentationStyle = .custom
          moveFolder.modalPresentationCapturesStatusBarAppearance = true
          moveFolder.transitioningDelegate = PanModalPresentationDelegate.default
          self.present(moveFolder, animated: true)
        } else {
          self.presentModal(moveFolder)
        }

      }
      .disposed(by: disposeBag)

    contentView.thumbnail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(thumbnailTapped)))
  }

  @objc
  private func thumbnailTapped() {
    guard let reactor,
          let url = URL(string: reactor.currentState.link.url) else { return }

    reactor.action.onNext(.readLink(reactor.currentState.link.id))

    let options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:]

    UIApplication.shared.open(url, options: options)
  }

  private func bindRoute(with reactor: LinkDetailViewReactor) {
    reactor.state.map(\.isDeleted)
      .asObservable()
      .filter { $0 }
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, _ in
        self.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
  }
}


// MARK: - NavigationBar

extension LinkDetailViewController {

  private func configureNavigationBar() {
    let backButton = UIBarButtonItem(
      image: DesignSystemAsset.iconPop.image.withTintColor(.staticBlack),
      style: .plain,
      target: self,
      action: #selector(pop)
    )

    let shareButton = UIBarButtonItem(
      image: DesignSystemAsset.iconUpload.image.withTintColor(.staticBlack),
      style: .plain,
      target: self,
      action: #selector(share)
    )

    navigationItem.leftBarButtonItem = backButton
    navigationItem.leftBarButtonItem?.tintColor = .staticBlack
    navigationItem.rightBarButtonItem = shareButton
    navigationItem.rightBarButtonItem?.tintColor = .staticBlack
    navigationItem.title = "링크 상세정보"

    let attributes = [
      NSAttributedString.Key.foregroundColor: UIColor.staticBlack,
      NSAttributedString.Key.font: UIFont.defaultRegular,
    ]
    navigationController?.navigationBar.titleTextAttributes = attributes
  }

  @objc
  private func pop() {
    navigationController?.popViewController(animated: true)
  }

  @objc
  private func share() {
    guard let url = reactor?.currentState.link.url else {
      return
    }

    let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)

    activityViewController.excludedActivityTypes = []
    present(activityViewController, animated: true, completion: nil)
  }
}


// MARK: CreateLinkDelegate

extension LinkDetailViewController: CreateLinkDelegate {
  func createLinkSucceed(link: Link) {
    contentView.configure(withLink: link)
    PBToast(content: "변경사항이 저장되었어요.")
      .show()
  }
}


// MARK: MoveFolderDelegate

extension LinkDetailViewController: MoveFolderDelegate {
  func moveFolderSuccess(folder: Folder) {
    reactor?.action.onNext(.moveFolder(folder))
    contentView.configureFolder(withFolder: folder)
    PBToast(content: "변경사항이 저장되었어요.")
      .show()
  }
}
