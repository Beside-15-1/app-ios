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
    $0.text = "태그 목록"
    $0.textColor = .staticBlack
    $0.font = .subTitleSemiBold
  }

  private let tagCountLabel = UILabel().then {
    $0.textColor = .gray600
    $0.font = .defaultRegular
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
    $0.text = "아직 선택된 태그가 없어요"
    $0.textColor = .gray500
    $0.font = .bodyRegular
  }

  // MARK: Properties

  private var tags: [String] = []
  private var selectedTags: [String] = []
  weak var delegate: TagListViewDelegate?

  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: Configuring

  func configureTagCount(count: Int) {
    tagCountLabel.text = "\(count)/10"
  }

  // MARK: TableView

  func applyTagList(by tags: [String], selected list: [String]) {
    self.tags = tags
    selectedTags = list

    emptyLabel.isHidden = !tags.isEmpty

    tableView.reloadData()

    list.forEach {
      if let index = tags.firstIndex(of: $0) {
        guard let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0))
          as? TagListCell else { return }
        cell.configureSelected(isSelected: true)
      }
    }
  }

  // MARK: Layout

  private func defineLayout() {
    addSubview(titleLabel)
    addSubview(tagCountLabel)
    addSubview(emptyLabel)
    addSubview(tableView)

    titleLabel.snp.makeConstraints {
      $0.top.left.equalToSuperview()
    }

    tagCountLabel.snp.makeConstraints {
      $0.left.equalTo(titleLabel.snp.right).offset(8.0)
      $0.bottom.equalTo(titleLabel)
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

    var isSelected = selectedTags.contains(where: { $0 == tags[indexPath.row] })

    return cell.then {
      $0.selectionStyle = .none
      $0.configureText(text: self.tags[indexPath.row])
      $0.configureSelected(isSelected: isSelected)
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
