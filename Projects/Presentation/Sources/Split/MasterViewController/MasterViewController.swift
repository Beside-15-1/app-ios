//
//  MasterViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/28.
//

import UIKit

import ReactorKit
import RxSwift

import PresentationInterface

final class MasterViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = MasterView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  weak var delegate: MasterDelegate?

  var indexPathForCurrentSelectedCell: IndexPath?

  // MARK: Initializing

  init(reactor: MasterViewReactor) {
    defer { self.reactor = reactor }
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView
    contentView.tableView.delegate = self
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

  func bind(reactor: MasterViewReactor) {
    bindButtons(with: reactor)
    bindContent(with: reactor)
  }

  private func bindButtons(with reactor: MasterViewReactor) {
    contentView.masterDetailButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.splitViewController?.changeDisplayMode(to: .secondaryOnly)
      }
      .disposed(by: disposeBag)
  }

  private func bindContent(with reactor: MasterViewReactor) {
    reactor.state.compactMap(\.viewModel)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, viewModel in
        self.contentView.applyTableViewDataSource(by: viewModel.items)

        let firstIndex = IndexPath(row: 0, section: 0)

        if reactor.currentState.isFirstAPICall {
          self.contentView.tableView.selectRow(
            at: IndexPath(row: 0, section: 0),
            animated: false,
            scrollPosition: .top
          )
          self.indexPathForCurrentSelectedCell = firstIndex
          let cell = self.contentView.tableView.cellForRow(at: firstIndex)
          cell?.contentView.backgroundColor = .staticWhite

          reactor.action.onNext(.firstAPICallEnded)
        }
      }
      .disposed(by: disposeBag)
  }
}


// MARK: - Private

extension MasterViewController {

  private func delegateAction(withViewModel viewModel: MasterTabCell.ViewModel) {
    if let tab = viewModel.tabViewType {
      switch tab {
      case .home:
        delegate?.masterHomeTapped()
      case .folder:
        delegate?.masterFolderTapped()
      case .mypage:
        delegate?.masterMyPageTapped()
      }
    }

    if let folder = viewModel.folderViewModel {
      delegate?.masterFolderTapped(id: folder.id)
    }

    if viewModel.isMakeButton {
      let indexPath = IndexPath(row: 1, section: 0)
      let currentCell = contentView.tableView.cellForRow(at: indexPathForCurrentSelectedCell ?? indexPath)
      currentCell?.contentView.backgroundColor = .gray300
      let folderTabCell = contentView.tableView.cellForRow(at: indexPath)
      folderTabCell?.contentView.backgroundColor = .staticWhite
      indexPathForCurrentSelectedCell = indexPath
      delegate?.masterMakeFolderButtonTapped()
    }
  }
}


// MARK: - TableViewDelegate

extension MasterViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let viewModel = reactor?.currentState.viewModel?.items[indexPath.row] else {
      return
    }

    if let indexPathForCurrentSelectedCell {

      if reactor?.currentState.viewModel?.items[indexPath.row].isMakeButton == false {
        let deselectedCell = tableView.cellForRow(at: indexPathForCurrentSelectedCell)
        deselectedCell?.contentView.backgroundColor = .gray300
      } else {
        delegateAction(withViewModel: viewModel)
        return
      }
    }

    let cell = tableView.cellForRow(at: indexPath)
    cell?.contentView.backgroundColor = .staticWhite
    indexPathForCurrentSelectedCell = indexPath

    delegateAction(withViewModel: viewModel)
  }
}
