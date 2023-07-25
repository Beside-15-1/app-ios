//
//  ManageTagViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import Foundation

import RxRelay
import RxSwift

import PBUserDefaults

// MARK: - TagAddViewModelInput

protocol ManageTagViewReactorInput {
  func inputText(text: String)
  func addTag(text: String)
  func editTag(text: String)
  func removeTagListTag(at row: Int)
  func changeEditMode(text: String)
}

// MARK: - TagAddViewModelOutput

protocol ManageTagViewReactorOutput {
  var localTagList: BehaviorRelay<[String]> { get }
  var validatedText: PublishRelay<String> { get }
  var shouldShowTagLimitToast: PublishRelay<Void> { get }
}

// MARK: - TagAddViewModel

final class ManageTagViewReactor: ManageTagViewReactorOutput {
  enum TagInputMode {
    case input
    case edit
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  var tagInputMode: TagInputMode = .input
  var editedTag: String? = nil

  private let userDefaults: UserDefaultsManager

  // MARK: Output

  var localTagList: BehaviorRelay<[String]> = .init(value: [])
  var validatedText: PublishRelay<String> = .init()
  var shouldShowTagLimitToast: PublishRelay<Void> = .init()

  // MARK: initializing

  init(
    userDefaults: UserDefaultsManager
  ) {
    self.userDefaults = userDefaults
    localTagList.accept(userDefaults.tagList)
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Output
}

// MARK: ManageTagViewReactor

extension ManageTagViewReactor: ManageTagViewReactorInput {
  func addTag(text: String) {
    if tagInputMode == .input {

      // 태그 리스트에 추가
      var tagList = localTagList.value
      if !tagList.contains(where: { $0 == text }) {
        tagList.insert(text, at: 0)
      }
      localTagList.accept(tagList)
      userDefaults.tagList = tagList
      // 유저디폴트에 저장
    }
  }

  func editTag(text: String) {
    if tagInputMode == .edit {
      guard let editedTag else { return }

      var tagList = localTagList.value
      if let index = tagList.firstIndex(of: editedTag) {
        tagList[index] = text
      }
      localTagList.accept(tagList)
      userDefaults.tagList = tagList
    }

    tagInputMode = .input
    editedTag = nil
  }

  func removeTagListTag(at row: Int) {
    var local = localTagList.value

    local.remove(at: row)
    localTagList.accept(local)
    userDefaults.tagList = local
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
