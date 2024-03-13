import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

protocol TagListViewDelegate: AnyObject {
  func tagListView(_ tagListView: TagListView, didSelectedRow at: Int)
  func updateTagList(_ tagListView: TagListView, tagList: [String])
  func removeTag(_ tagListView: TagListView, row at: Int)
}


final class TagListView: UIView {
  var editHandler: ((String) -> Void)? = nil

  typealias Section = TagListSection
  typealias SectionItem = TagListSection.Item
  private typealias DiffableDataSource = TagListViewDataSource
  private typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>


  // MARK: UI

  private let titleLabel = UILabel().then {
    $0.text = "최근 사용한 태그"
    $0.textColor = .staticBlack
    $0.font = .subTitleSemiBold
  }

  lazy var tableView = UITableView(frame: .zero, style: .plain).then {
    $0.register(TagListCell.self, forCellReuseIdentifier: TagListCell.identifier)
    $0.backgroundColor = .clear
    $0.delegate = self
    $0.dragInteractionEnabled = true
    $0.dropDelegate = self
    $0.dragDelegate = self
    $0.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
  }

  private let emptyLabel = UILabel().then {
    $0.text = "아직 등록된 태그가 없어요."
    $0.textColor = .gray500
    $0.font = .bodyRegular
  }


  // MARK: Properties

  private var tags: [String] = []
  weak var delegate: TagListViewDelegate?

  private lazy var dataSource: DiffableDataSource = diffableDataSource()

  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: TableView

  private func diffableDataSource() -> DiffableDataSource {
    TagListViewDataSource(
      tagListView: self,
      tableView: tableView
    ) { tableView, indexPath, item in
      switch item {
      case .normal(let tag):
        let cell = tableView.dequeueReusableCell(withIdentifier: TagListCell.identifier)
          as? TagListCell

        return cell?.then {
          $0.selectionStyle = .none
          $0.configureText(text: tag)
        }
      }
    }
  }

  func applyTagList(by items: [SectionItem]) {
    tags = items.map { item in
      switch item {
      case .normal(let tag):
        return tag
      }
    }

    var snapshot = DiffableSnapshot()
    snapshot.appendSections([.items])
    snapshot.appendItems(items)

    emptyLabel.isHidden = !items.isEmpty

    dataSource.apply(snapshot, animatingDifferences: false)
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(titleLabel)
    addSubview(emptyLabel)
    addSubview(tableView)

    titleLabel.snp.makeConstraints {
      $0.top.left.equalToSuperview()
    }

    tableView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
      $0.left.right.bottom.equalToSuperview()
    }

    emptyLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(32.0)
    }
  }
}

// MARK: UITableViewDragDelegate

extension TagListView: UITableViewDragDelegate {
  func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    [UIDragItem(itemProvider: NSItemProvider())]
  }
}

// MARK: UITableViewDropDelegate
extension TagListView: UITableViewDropDelegate {
  func tableView(
    _ tableView: UITableView,
    dropSessionDidUpdate session: UIDropSession,
    withDestinationIndexPath destinationIndexPath: IndexPath?
  ) -> UITableViewDropProposal {
    if session.localDragSession != nil {
      return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
  }

  func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
}


// MARK: UITableViewDelegate, UITableViewDataSource

extension TagListView: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.tagListView(self, didSelectedRow: indexPath.row)
  }

  func tableView(
    _ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
      guard let self else { return }
      delegate?.removeTag(self, row: indexPath.row)
      completion(true)
    }

    let editAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
      guard let self else { return }
      // TODO: 편집 기능
      editHandler?(tags[indexPath.row])
      completion(true)
    }
    deleteAction.backgroundColor = .error
    deleteAction.image = DesignSystemAsset.textDelete.image
    editAction.backgroundColor = .blue
    editAction.image = DesignSystemAsset.textEdit.image

    if tableView.isEditing {
      return nil
    }

    return .init(actions: [deleteAction, editAction]).then {
      $0.performsFirstActionWithFullSwipe = false
    }
  }

  class TagListViewDataSource: UITableViewDiffableDataSource<TagListSection, TagListSection.Item> {

    init(
      tagListView: TagListView,
      tableView: UITableView,
      cellProvider: @escaping UITableViewDiffableDataSource<TagListSection, TagListSection.Item>.CellProvider
    ) {
      self.tagListView = tagListView
      super.init(tableView: tableView, cellProvider: cellProvider)
    }

    var tagListView: TagListView

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
      let movedObject = tagListView.tags[sourceIndexPath.row]
      tagListView.tags.remove(at: sourceIndexPath.row)
      tagListView.tags.insert(movedObject, at: destinationIndexPath.row)
      tagListView.delegate?.updateTagList(tagListView, tagList: tagListView.tags)
    }
  }
}
