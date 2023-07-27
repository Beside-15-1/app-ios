import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

// MARK: - TagListSection

enum TagListSection {
  case normal
}

// MARK: - TagListViewDelegate

protocol TagListViewDelegate: AnyObject {
  func tagListView(_ tagListView: TagListView, didSelectedRow at: Int)
  func updateTagList(_ tagListView: TagListView, tagList: [String])
  func removeTag(_ tagListView: TagListView, row at: Int)
}

// MARK: - TagListView

final class TagListView: UIView {
  var editHandler: ((String) -> Void)? = nil

  // MARK: UI

  private let titleLabel = UILabel().then {
    $0.text = "최근 사용한 태그"
    $0.textColor = .staticBlack
    $0.font = .subTitleSemiBold
  }

  lazy var tableView = UITableView(frame: .zero, style: .plain).then {
    $0.register(TagListCell.self, forCellReuseIdentifier: TagListCell.identifier)
    $0.backgroundColor = .clear
    $0.dataSource = self
    $0.delegate = self
    $0.dragInteractionEnabled = true
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

  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: TableView

  func applyTagList(by tags: [String]) {
    self.tags = tags

    emptyLabel.isHidden = !tags.isEmpty

    tableView.reloadData()
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
    return [UIDragItem(itemProvider: NSItemProvider())]
  }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension TagListView: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tags.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: TagListCell.identifier, for: indexPath
    ) as? TagListCell else { return UITableViewCell() }

    return cell.then {
      $0.selectionStyle = .none
      $0.configureText(text: self.tags[indexPath.row])
    }
  }

  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    true
  }

  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let movedObject = tags[sourceIndexPath.row]
    tags.remove(at: sourceIndexPath.row)
    tags.insert(movedObject, at: destinationIndexPath.row)
    delegate?.updateTagList(self, tagList: tags)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.tagListView(self, didSelectedRow: indexPath.row)
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
      guard let self else { return }
      self.tags.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      self.delegate?.removeTag(self, row: indexPath.row)
      completion(true)
    }

    let editAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
      guard let self else { return }
      // TODO: 편집 기능
      self.editHandler?(self.tags[indexPath.row])
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

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
}
