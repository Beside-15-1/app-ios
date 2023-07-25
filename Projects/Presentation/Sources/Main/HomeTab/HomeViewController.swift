//
//  HomeViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/05.
//

import UIKit

import ReactorKit
import RxSwift
import Toaster

import DesignSystem
import Domain
import PBLog
import PresentationInterface

final class HomeViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = HomeView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let createLinkBuilder: CreateLinkBuildable
  private let createFolderBuilder: CreateFolderBuildable
  private let folderDetailBuilder: FolderDetailBuildable
  private let webBuilder: PBWebBuildable

  // MARK: Initializing

  init(
    reactor: HomeViewReactor,
    createLinkBuilder: CreateLinkBuildable,
    createFolderBuilder: CreateFolderBuildable,
    folderDetailBuilder: FolderDetailBuildable,
    webBuilder: PBWebBuildable
  ) {
    defer { self.reactor = reactor }
    self.createLinkBuilder = createLinkBuilder
    self.createFolderBuilder = createFolderBuilder
    self.folderDetailBuilder = folderDetailBuilder
    self.webBuilder = webBuilder
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView

    contentView.homeFolderView.delegate = self
    contentView.homeLinkView.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    reactor?.action.onNext(.viewDidLoad)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reactor?.action.onNext(.viewWillAppear)
    navigationController?.isNavigationBarHidden = true
  }


  // MARK: Binding

  func bind(reactor: HomeViewReactor) {
    bindButtons(with: reactor)
    bindContent(with: reactor)
  }

  private func bindButtons(with reactor: HomeViewReactor) {
    contentView.fab.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        let vc = self.createLinkBuilder.build(payload: .init(
          delegate: self,
          link: nil
        ))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
      }
      .disposed(by: disposeBag)

    contentView.homeLinkView.newLinkButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        let vc = self.createLinkBuilder.build(payload: .init(
          delegate: self,
          link: nil
        ))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
      }
      .disposed(by: disposeBag)

    contentView.homeFolderView.moveToFolderButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.tabBarController?.selectedIndex = 1
      }
      .disposed(by: disposeBag)

    contentView.viewAllButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        var folderList = reactor.currentState.folderList
        folderList.insert(.all(), at: 0)

        let folderDetail = self.folderDetailBuilder.build(
          payload: .init(
            folderList: folderList,
            selectedFolder: .all()
          )
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          self.tabBarController?.selectedViewController?
            .navigationController?.pushViewController(
              folderDetail, animated: true
            )
        }
      }
      .disposed(by: disposeBag)
  }

  private func bindContent(with reactor: HomeViewReactor) {
    reactor.state.compactMap(\.folderViewModel)
      .distinctUntilChanged()
      .asObservable()
      .subscribe(with: self) { `self`, viewModel in
        self.contentView.homeFolderView.applyCollectionViewDataSource(by: viewModel)
      }
      .disposed(by: disposeBag)

    reactor.state.compactMap(\.linkViewModel)
      .distinctUntilChanged()
      .asObservable()
      .subscribe(with: self) { `self`, viewModel in
        self.contentView.homeLinkView.applyCollectionViewDataSource(by: viewModel)
      }
      .disposed(by: disposeBag)
  }
}


// MARK: HomeFolderViewDelegate

extension HomeViewController: HomeFolderViewDelegate {
  func createFolderDidTapped() {
    let vc = createFolderBuilder.build(
      payload: .init(
        folder: nil,
        delegate: self
      )
    ).then {
      $0.modalPresentationStyle = .popover
    }

    present(vc, animated: true)
  }

  func homeFolderView(didSelectItemAt row: Int) {
    // 라우팅
    guard let folderList = reactor?.currentState.folderList
    else { return }

    var newFolderList = folderList
    newFolderList.insert(.all(), at: 0)

    let folderDetail = folderDetailBuilder.build(
      payload: .init(
        folderList: newFolderList,
        selectedFolder: folderList[row]
      )
    )

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.tabBarController?.selectedViewController?
        .navigationController?.pushViewController(
          folderDetail, animated: true
        )
    }
  }
}


// MARK: CreateFolderDelegate

extension HomeViewController: CreateFolderDelegate {
  func createFolderSucceed() {
    reactor?.action.onNext(.createFolderSucceed)
  }
}


extension HomeViewController: CreateLinkDelegate {
  func createLinkSucceed(link: Link) {
    reactor?.action.onNext(.createLinkSucceed)

    PBToast(content: "링크가 저장되었습니다")
      .show()
  }
}


extension HomeViewController: HomeLinkViewDelegate {
  func homeLinkView(_ homeLinkView: HomeLinkView, didSelectItemAt row: Int) {
    guard let reactor else { return }
    guard row < reactor.currentState.folderList.count else {
      let folderDetail = folderDetailBuilder.build(
        payload: .init(
          folderList: reactor.currentState.folderList,
          selectedFolder: .all()
        )
      )

      tabBarController?.selectedViewController?
        .navigationController?.pushViewController(
          folderDetail, animated: true
        )
      return
    }

    guard let url = URL(string: reactor.currentState.linkList[row].url) else {
      return
    }

    let web = webBuilder.build(payload: .init(url: url))
    web.modalPresentationStyle = .popover

    present(web, animated: true)
  }
}
