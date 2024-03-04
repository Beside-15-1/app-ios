//
//  ManageTagViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import Foundation

import ReactorKit
import RxRelay
import RxSwift

import Domain
import PBAnalyticsInterface
import PBUserDefaults


final class ManageTagViewReactor: Reactor {

  enum TagInputMode {
    case input
    case edit
  }

  enum Action {
    case viewDidLoad
    case viewDidAppear
    case editButtonTapped(Tag)
    case endEditing
    case returnButtonTapped(Tag)
    case tagListTagRemoveButtonTapped(at: Int)
    case replaceTagOrder([Tag])
    case inputText(String)
    case syncTagList
  }

  enum Mutation {
    case setTagList([Tag])
    case setTagInputMode(TagInputMode)
    case setEditedTag(Tag?)
    case setShouldShowTagLimitToast
    case setValidatedText(String)
  }

  struct State {
    var tagList: [Tag] = []

    var tagInputMode: TagInputMode = .input
    var editedTag: Tag?

    var validatedText = ""

    @Pulse var shouldShowTagLimitToast = false
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let analytics: PBAnalytics
  private let tagRepository: TagRepository

  var isFirst = true


  // MARK: initializing

  init(
    analytics: PBAnalytics,
    tagRepository: TagRepository
  ) {
    defer { _ = self.state }

    self.analytics = analytics
    self.tagRepository = tagRepository

    self.initialState = State()
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return fetchTagList()

    case .viewDidAppear:

      analytics.log(type: SettingTagEvent.shown)

      return .empty()

    case .editButtonTapped(let tag):
      analytics.log(type: SettingTagEvent.click(component: .editTag))

      return .concat([
        .just(Mutation.setTagInputMode(.edit)),
        .just(Mutation.setEditedTag(tag)),
      ])

    case .endEditing:
      return .concat([
        .just(Mutation.setEditedTag(nil)),
        .just(Mutation.setTagInputMode(.input)),
      ])

    case .returnButtonTapped(let tag):
      return returnButtonAction(tag: tag)

    case .tagListTagRemoveButtonTapped(let index):
      analytics.log(type: SettingTagEvent.click(component: .deleteTag))
      return removeTagListTag(at: index)

    case .replaceTagOrder(let tagList):
      return .just(Mutation.setTagList(tagList))

    case .inputText(let text):
      var validatedText = text
      if text.count > 9 {
        validatedText = String(text[text.startIndex...text.index(text.startIndex, offsetBy: 9)])
      }

      return .just(Mutation.setValidatedText(validatedText))

    case .syncTagList:
      saveTagListToRemote(tagList: currentState.tagList)

      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setTagList(let tagList):
      newState.tagList = tagList

    case .setTagInputMode(let inputMode):
      newState.tagInputMode = inputMode

    case .setEditedTag(let tag):
      newState.editedTag = tag

    case .setShouldShowTagLimitToast:
      newState.shouldShowTagLimitToast = true

    case .setValidatedText(let text):
      newState.validatedText = text
    }

    return newState
  }
}


// MARK: - Private

extension ManageTagViewReactor {

  private func fetchTagList() -> Observable<Mutation> {
    tagRepository.fetchTagList()
      .asObservable()
      .map { Mutation.setTagList($0) }
  }

  private func returnButtonAction(tag: Tag) -> Observable<Mutation> {
    switch currentState.tagInputMode {
    case .input:
      analytics.log(type: SettingTagEvent.click(component: .inputbox))
      var tagList = currentState.tagList

      if !tagList.contains(where: { $0 == tag }) {
        tagList.insert(tag, at: 0)
      }

      return .just(Mutation.setTagList(tagList))

    case .edit:
      guard let editedTag = currentState.editedTag else { return .empty() }

      var tagList = currentState.tagList

      if let index = tagList.firstIndex(of: editedTag) {
        tagList[index] = tag
      }

      return .concat([
        .just(Mutation.setTagList(tagList)),
        .just(Mutation.setEditedTag(nil)),
      ])
    }
  }

  func removeTagListTag(at row: Int) -> Observable<Mutation> {
    var tagList = currentState.tagList

    tagList.remove(at: row)

    return .just(Mutation.setTagList(tagList))
  }

  func saveTagListToRemote(tagList: [Tag]) {
    guard !isFirst else {
      isFirst = false
      return
    }

    return tagRepository.updateTagList(tagList: tagList)
      .subscribe()
      .disposed(by: disposeBag)
  }

  func deleteTagToRemote(tag: Tag) {
    tagRepository.deleteTag(tag: tag)
      .subscribe()
      .disposed(by: disposeBag)
  }
}
