import Foundation

import RxRelay
import RxSwift

// MARK: - TagAddViewModelInput

protocol TagAddViewModelInput {
  func inputText(text: String)
  func addTag(text: String)
  func removeAddedTag(at row: Int)
  func removeTagListTag(at row: Int)
}

// MARK: - TagAddViewModelOutput

protocol TagAddViewModelOutput {
  var addedTagList: BehaviorRelay<[String]> { get }
  var localTagList: BehaviorRelay<[String]> { get }
  var validatedText: PublishRelay<String> { get }
}

// MARK: - TagAddViewModel

final class TagAddViewModel: TagAddViewModelOutput {
  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: Output

  var addedTagList: BehaviorRelay<[String]> = .init(value: [])
  var localTagList: BehaviorRelay<[String]> = .init(value: [])
  var validatedText: PublishRelay<String> = .init()

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
}
