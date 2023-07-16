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
import PresentationInterface

final class MyFolderViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = MyFolderView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let createFolderBuilder: CreateFolderBuildable
  private let editFolderBuilder: EditFolderBuildable
  private let folderSortBuilder: FolderSortBuildable


  // MARK: Initializing

  init(
    reactor: MyFolderViewReactor,
    createFolderBuilder: CreateFolderBuildable,
    editFolderBuilder: EditFolderBuildable,
    folderSortBuilder: FolderSortBuildable
  ) {
    defer { self.reactor = reactor }

    self.createFolderBuilder = createFolderBuilder
    self.editFolderBuilder = editFolderBuilder
    self.folderSortBuilder = folderSortBuilder

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView

    contentView.myFolderCollectionView.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    reactor?.action.onNext(.viewDidLoad)
  }


  // MARK: Binding

  func bind(reactor: MyFolderViewReactor) {
    bindContent(with: reactor)
    bindTextField(with: reactor)
    bindButton(with: reactor)
  }

  private func bindContent(with reactor: MyFolderViewReactor) {
    reactor.state.compactMap(\.folderViewModel)
      .asObservable()
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, viewModel in
        self.contentView.myFolderCollectionView.applyCollectionViewDataSource(by: viewModel)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.folderSortType)
      .asObservable()
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, type in
        self.contentView.myFolderCollectionView.sortButton.text = type.rawValue
      }
      .disposed(by: disposeBag)
  }

  private func bindTextField(with reactor: MyFolderViewReactor) {
    contentView.folderSearchField.rx.text
      .subscribe(with: self) { `self`, text in
        reactor.action.onNext(.searchText(text))
        self.contentView.myFolderCollectionView.configureEmptyLabel(text: text)
      }
      .disposed(by: disposeBag)
  }

  private func bindButton(with reactor: MyFolderViewReactor) {
    contentView.myFolderCollectionView.createFolderButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        let vc = self.createFolderBuilder.build(
          payload: .init(
            folder: nil,
            delegate: self
          )
        ).then {
          $0.modalPresentationStyle = .popover
        }

        self.present(vc, animated: true)
      }
      .disposed(by: disposeBag)

    contentView.myFolderCollectionView.sortButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let vc = self.folderSortBuilder.build(
          payload: .init(
            delegate: self,
            sortType: reactor.currentState.folderSortType
          )
        ) as? PanModalPresentable.LayoutType else { return }

        self.presentPanModal(vc)
      }
      .disposed(by: disposeBag)
  }
}


// MARK: CreateFolderDelegate

extension MyFolderViewController: CreateFolderDelegate {
  func createFolderSucceed() {
    reactor?.action.onNext(.createFolderSucceed)
  }
}


// MARK: MyFolderCollectionViewDelegate

extension MyFolderViewController: MyFolderCollectionViewDelegate {
  func collectionViewEditButtonTapped(id: String) {
    guard let reactor,
          let folder = reactor.currentState.folderList.first(where: { $0.id == id })
    else { return }

    guard let vc = editFolderBuilder.build(payload: .init(
      delegate: self,
      folder: folder
    ))
      as? PanModalPresentable.LayoutType else { return }

    presentPanModal(vc)
  }
}


extension MyFolderViewController: EditFolderDelegate {
  func editFolderModifyButtonTapped(withFolder folder: Folder) {
    let vc = createFolderBuilder.build(
      payload: .init(
        folder: folder,
        delegate: self
      )
    ).then {
      $0.modalPresentationStyle = .popover
    }

    present(vc, animated: true)
  }

  func editFolderDeleteButtonTapped(withFolder folder: Folder) {
    PBDialog(
      title: "정말로 삭제하시겠습니까??",
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