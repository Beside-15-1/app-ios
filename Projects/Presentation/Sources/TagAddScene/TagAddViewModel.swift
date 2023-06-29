import Foundation

import RxRelay
import RxSwift

// MARK: - TagAddViewModelInput

protocol TagAddViewModelInput {
  func inputText(text: String)
  func addTag(text: String)
  func editTag(text: String)
  func removeAddedTag(at row: Int)
  func removeTagListTag(at row: Int)
  func changeEditMode(text: String)
}

// MARK: - TagAddViewModelOutput

protocol TagAddViewModelOutput {
  var addedTagList: BehaviorRelay<[String]> { get }
  var localTagList: BehaviorRelay<[String]> { get }
  var validatedText: PublishRelay<String> { get }
  var shouldShowTagLimitToast: PublishRelay<Void> { get }
}

// MARK: - TagAddViewModel

final class TagAddViewModel: TagAddViewModelOutput {
  enum TagInputMode {
    case input
    case edit
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  var tagInputMode: TagInputMode = .input
  var editedTag: String? = nil

  // MARK: Output

  var addedTagList: BehaviorRelay<[String]> = .init(value: [])
  var localTagList: BehaviorRelay<[String]> = .init(value: [])
  var validatedText: PublishRelay<String> = .init()
  var shouldShowTagLimitToast: PublishRelay<Void> = .init()

  // MARK: initializing

  init(
    addedTagList: [String]
  ) {
    self.addedTagList.accept(addedTagList)
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Output
}

// MARK: TagAddViewModelInput

extension TagAddViewModel: TagAddViewModelInput {
  func addTag(text: String) {
    if tagInputMode == .input {
      guard addedTagList.value.count < 10 else {
        shouldShowTagLimitToast.accept(())
        var tagList = localTagList.value
        if !tagList.contains(where: { $0 == text }) {
          tagList.append(text)
        }
        localTagList.accept(tagList)
        return
      }

      // AddedTag에 추가
      var addedTag = addedTagList.value
      if !addedTag.contains(where: { $0 == text }) {
        addedTag.append(text)
        addedTagList.accept(addedTag)
      }

      // 태그 리스트에 추가
      var tagList = localTagList.value
      if !tagList.contains(where: { $0 == text }) {
        tagList.append(text)
      }
      localTagList.accept(tagList)
      // 유저디폴트에 저장
    }
  }

  func editTag(text: String) {
    if tagInputMode == .edit {
      guard let editedTag else { return }

      var addedTag = addedTagList.value
      if let index = addedTag.firstIndex(of: editedTag) {
        addedTag[index] = text
        addedTagList.accept(addedTag)
      }

      var tagList = localTagList.value
      if let index = tagList.firstIndex(of: editedTag) {
        tagList[index] = text
      }
      localTagList.accept(tagList)
    }

    tagInputMode = .input
    editedTag = nil
  }

  func removeAddedTag(at row: Int) {
    var addedTag = addedTagList.value
    addedTag.remove(at: row)
    addedTagList.accept(addedTag)
  }

  func removeTagListTag(at row: Int) {
    var local = localTagList.value
    let removedTag = localTagList.value[row]

    guard let removedRowInAddedList = addedTagList.value.firstIndex(of: removedTag) else {
      local.remove(at: row)
      localTagList.accept(local)
      return
    }

    local.remove(at: row)
    localTagList.accept(local)

    removeAddedTag(at: removedRowInAddedList)
  }

  func inputText(text: String) {
    if text.count > 9 {
      let validatedText = text[text.startIndex...text.index(text.startIndex, offsetBy: 9)]
      self.validatedText.accept(String(validatedText))
    }
  }

  func changeEditMode(text: String) {
    tagInputMode = .edit
    editedTag = text
    validatedText.accept(text)
  }
}
