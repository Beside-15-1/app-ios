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

  // MARK: Initializing

  init(
    reactor: HomeViewReactor,
    createLinkBuilder: CreateLinkBuildable,
    createFolderBuilder: CreateFolderBuildable,
    folderDetailBuilder: FolderDetailBuildable
  ) {
    defer { self.reactor = reactor }
    self.createLinkBuilder = createLinkBuilder
    self.createFolderBuilder = createFolderBuilder
    self.folderDetailBuilder = folderDetailBuilder
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView

    contentView.homeFolderView.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    reactor?.action.onNext(.viewDidLoad)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

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
          delegate: self
        ))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
      }
      .disposed(by: disposeBag)

    contentView.homeLinkView.newLinkButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        let vc = self.createLinkBuilder.build(payload: .init(
          delegate: self
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
        self.tabBarController?.selectedIndex = 1

        let folderDetail = self.folderDetailBuilder.build(
          payload: .init(
            folderList: reactor.currentState.folderList,
            selectedFolder: .all()
          )
        )

        self.tabBarController?.selectedViewController?
          .navigationController?.pushViewController(
            folderDetail, animated: true
          )
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
    guard let folder = reactor?.currentState.folderList[row] else { return }
    PBLog.info(folder)
  }
}


// MARK: CreateFolderDelegate

extension HomeViewController: CreateFolderDelegate {
  func createFolderSucceed() {
    reactor?.action.onNext(.createFolderSucceed)
  }
}


extension HomeViewController: CreateLinkDelegate {
  func createLinkSucceed() {
    reactor?.action.onNext(.createLinkSucceed)

    PBToast(content: "링크가 저장되었습니다")
      .show()
  }
}
