//
//  MyFolderViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/11.
//

import UIKit

import PanModal
import ReactorKit
import RxSwift

import DesignSystem
import Domain
import PBAnalyticsInterface
import PresentationInterface

final class MyFolderViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = MyFolderView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let analytics: PBAnalytics
  private let createFolderBuilder: CreateFolderBuildable
  private let editFolderBuilder: EditFolderBuildable
  private let folderSortBuilder: FolderSortBuildable
  private let folderDetailBuilder: FolderDetailBuildable
  private let createLinkBuilder: CreateLinkBuildable

  private let orientationController = OrientationController()


  // MARK: Initializing

  init(
    reactor: MyFolderViewReactor,
    analytics: PBAnalytics,
    createFolderBuilder: CreateFolderBuildable,
    editFolderBuilder: EditFolderBuildable,
    folderSortBuilder: FolderSortBuildable,
    folderDetailBuilder: FolderDetailBuildable,
    createLinkBuilder: CreateLinkBuildable
  ) {
    defer { self.reactor = reactor }

    self.analytics = analytics
    self.createFolderBuilder = createFolderBuilder
    self.editFolderBuilder = editFolderBuilder
    self.folderSortBuilder = folderSortBuilder
    self.folderDetailBuilder = folderDetailBuilder
    self.createLinkBuilder = createLinkBuilder

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView

    contentView.myFolderListView.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    reactor?.action.onNext(.viewDidLoad)

    orientationController.register(delegate: self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.isNavigationBarHidden = true
    reactor?.action.onNext(.viewWillAppear)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    analytics.log(type: MyFolderEvent.shown)
  }


  // MARK: Binding

  func bind(reactor: MyFolderViewReactor) {
    bindContent(with: reactor)
    bindTextField(with: reactor)
    bindButton(with: reactor)
  }

  private func bindContent(with reactor: MyFolderViewReactor) {
    reactor.state.compactMap(\.folderViewModel)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, viewModel in
        self.contentView.myFolderListView.applyCollectionViewDataSource(by: viewModel)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.folderSortType)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, type in
        self.contentView.myFolderListView.sortButton.text = type.rawValue
      }
      .disposed(by: disposeBag)
  }

  private func bindTextField(with reactor: MyFolderViewReactor) {
    contentView.folderSearchField.rx.text
      .subscribe(with: self) { `self`, text in
        reactor.action.onNext(.searchText(text))
        self.contentView.myFolderListView.configureEmptyLabel(text: text)
      }
      .disposed(by: disposeBag)
  }

  private func bindButton(with reactor: MyFolderViewReactor) {
    contentView.myFolderListView.createFolderButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in

        self.analytics.log(type: MyFolderEvent.click(component: .addFolder))

        let vc = self.createFolderBuilder.build(
          payload: .init(
            folder: nil,
            delegate: self
          )
        )

        self.presentPaperSheet(vc)
      }
      .disposed(by: disposeBag)

    contentView.myFolderListView.sortButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in

        self.analytics.log(type: MyFolderEvent.click(component: .sortBy))

        guard let vc = self.folderSortBuilder.build(
          payload: .init(
            delegate: self,
            sortType: reactor.currentState.folderSortType
          )
        ) as? PanModalPresentable.LayoutType else { return }

        self.presentModal(
          vc,
          preferredContentSize: .init(width: 375, height: 252 - self.view.safeAreaInsets.bottom),
          arrowDirection: .up,
          sourceView: self.contentView.myFolderListView.sortButton,
          sourceRect: .init(
            origin: .init(
              x: self.contentView.myFolderListView.sortButton.frame.width / 2,
              y: self.contentView.myFolderListView.sortButton.frame.height
            ),
            size: .zero
          )
        )
      }
      .disposed(by: disposeBag)

    contentView.fab.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in

        self.analytics.log(type: MyFolderEvent.click(component: .addLink))

        let vc = self.createLinkBuilder.build(payload: .init(
          delegate: self,
          link: nil
        ))

        self.presentPaperSheet(vc)
      }
      .disposed(by: disposeBag)

    contentView.navigationBar.masterDetailButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.splitViewController?.changeDisplayMode(to: .oneBesideSecondary)
        self.contentView.navigationBar.masterDetailButton.isHidden = true
      }
      .disposed(by: disposeBag)
  }

  // MARK: Configuring

  func configureMasterDetail(displayMode: UISplitViewController.DisplayMode) {
    DispatchQueue.main.async {
      if displayMode == .secondaryOnly {
        self.contentView.navigationBar.masterDetailButton.isHidden = false
      }

      self.contentView.myFolderListView.configureDisplayMode(displayMode: displayMode)
    }
  }

  func createFolder() {
    let vc = createFolderBuilder.build(
      payload: .init(
        folder: nil,
        delegate: self
      )
    )

    presentPaperSheet(vc)
  }
}


// MARK: CreateFolderDelegate

extension MyFolderViewController: CreateFolderDelegate {
  func createFolderSucceed(folder: Folder) {
    reactor?.action.onNext(.createFolderSucceed)
  }
}


// MARK: MyFolderCollectionViewDelegate

extension MyFolderViewController: MyFolderCollectionViewDelegate {
  func collectionViewEditButtonTapped(id: String) {
    guard let reactor,
          let folder = reactor.currentState.folderList.first(where: { $0.id == id }),
          let index = reactor.currentState.folderList.firstIndex(of: folder)
    else { return }

    guard let vc = editFolderBuilder.build(payload: .init(
      delegate: self,
      folder: folder
    )) as? PanModalPresentable.LayoutType else { return }

    guard let selectedCell = contentView.myFolderListView.collectionView
      .cellForItem(at: IndexPath(item: index, section: 0)) as? MyFolderCell
    else {
      presentModal(
        vc,
        preferredContentSize: CGSize(width: 375, height: 210 - view.safeAreaInsets.bottom),
        arrowDirection: .any,
        sourceView: contentView.myFolderListView.sortButton,
        sourceRect: .init(
          origin: .init(
            x: contentView.myFolderListView.sortButton.frame.width / 2,
            y: contentView.myFolderListView.sortButton.frame.height
          ),
          size: .zero
        )
      )
      return
    }

    presentModal(
      vc,
      preferredContentSize: CGSize(width: 375, height: 210 - view.safeAreaInsets.bottom),
      arrowDirection: .down,
      sourceView: selectedCell.moreButton,
      sourceRect: .init(
        origin: .init(x: 16, y: 0),
        size: .zero
      )
    )
  }

  func collectionViewItemDidTapped(at row: Int) {
    guard let reactor else { return }

    let folderDetail = folderDetailBuilder.build(
      payload: .init(
        folderList: reactor.currentState.folderList,
        selectedFolder: reactor.currentState.folderList[row]
      )
    )

    navigationController?.pushViewController(folderDetail, animated: true)
  }
}


extension MyFolderViewController: EditFolderDelegate {
  func editFolderModifyButtonTapped(withFolder folder: Folder) {
    let vc = createFolderBuilder.build(
      payload: .init(
        folder: folder,
        delegate: self
      )
    )

    presentPaperSheet(vc)
  }

  func editFolderDeleteButtonTapped(withFolder folder: Folder) {
    PBDialog(
      title: "정말로 삭제하시겠습니까?",
      content: "\(folder.title)폴더가 삭제되며\n삭제된 데이터는 복구되지 않습니다.",
      from: self
    )
    .addAction(content: "예", priority: .secondary, action: { [weak self] in
      self?.reactor?.action.onNext(.deleteFolder(folder))
    })
    .addAction(content: "아니오", priority: .primary, action: nil)
    .show()
  }
}


// MARK: - FolderSortDelegate

extension MyFolderViewController: FolderSortDelegate {
  func folderSortListItemTapped(type: FolderSortModel) {
    reactor?.action.onNext(.updateSort(type))
  }
}


extension MyFolderViewController: CreateLinkDelegate {
  func createLinkSucceed(link: Link) {
    reactor?.action.onNext(.createFolderSucceed)
  }
}


// MARK: - OrientationController

extension MyFolderViewController: OrientationDelegate {
  func didChangeOrientation(orientation: UIDeviceOrientation) {
    DispatchQueue.main.async {
      self.contentView.myFolderListView.configureOrientation(orientation: orientation)
    }
  }
}
