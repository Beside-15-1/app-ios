import Foundation

import ReactorKit
import RxRelay
import RxSwift

import Domain
import PBAnalyticsInterface
import PBUserDefaults


final class TagAddReactor: Reactor {

  enum TagInputMode {
    case input
    case edit
  }

  enum Action {
    case viewDidLoad
    case addTag(Tag)
    case editButtonTapped(Tag)
    case endEditing
    case returnButtonTapped(Tag)
    case addedTagRemoveButtonTapped(at: Int)
    case tagListTagRemoveButtonTapped(at: Int)
    case selectTag(at: Int)
    case replaceTagOrder([Tag])
  }

  enum Mutation {
    case setTagList([Tag])
    case setAddedTagList([Tag])
    case setTagInputMode(TagInputMode)
    case setEditedTag(Tag?)
    case setShouldShowTagLimitToast
  }

  struct State {
    var tagList: [Tag] = []
    var addedTagList: [Tag] = []

    var tagInputMode: TagInputMode = .input
    var editedTag: Tag?

    @Pulse var shouldShowTagLimitToast = false
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let analytics: PBAnalytics
  private let tagRepository: TagRepository


  // MARK: initializing

  init(
    analytics: PBAnalytics,
    tagRepository: TagRepository,
    addedTagList: [Tag]
  ) {
    defer { _ = self.state }

    self.analytics = analytics
    self.tagRepository = tagRepository

    self.initialState = State(
      addedTagList: addedTagList
    )
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return fetchTagList()

    case .addTag(let tag):
      return .empty()

    case .editButtonTapped(let tag):
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

    case .addedTagRemoveButtonTapped(let index):
      return removeAddedTag(at: index)

    case .tagListTagRemoveButtonTapped(let index):
      return removeTagListTag(at: index)

    case .selectTag(let index):
      return selectTag(at: index)

    case .replaceTagOrder(let tagList):
      return .just(Mutation.setTagList(tagList))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setTagList(let tagList):
      newState.tagList = tagList

    case .setAddedTagList(let addedTagList):
      newState.tagList = addedTagList

    case .setTagInputMode(let inputMode):
      newState.tagInputMode = inputMode

    case .setEditedTag(let tag):
      newState.editedTag = tag

    case .setShouldShowTagLimitToast:
      newState.shouldShowTagLimitToast = true
    }

    return newState
  }
}


// MARK: - Private

extension TagAddReactor {

  private func fetchTagList() -> Observable<Mutation> {
    tagRepository.fetchTagList()
      .asObservable()
      .map { Mutation.setTagList($0) }
  }

  private func returnButtonAction(tag: Tag) -> Observable<Mutation> {
    switch currentState.tagInputMode {
    case .input:
      var addedTagList = currentState.addedTagList
      var tagList = currentState.tagList

      guard addedTagList.count < 10 else {
        if !tagList.contains(where: { $0 == tag }) {
          tagList.insert(tag, at: 0)
        }

        return .concat([
          .just(Mutation.setShouldShowTagLimitToast),
          .just(Mutation.setTagList(tagList)),
        ])
      }

      if !addedTagList.contains(where: { $0 == tag }) {
        addedTagList.append(tag)
      }

      if !tagList.contains(where: { $0 == tag }) {
        tagList.insert(tag, at: 0)
      }

      return .concat([
        .just(Mutation.setAddedTagList(addedTagList)),
        .just(Mutation.setTagList(tagList)),
      ])

    case .edit:
      guard let editedTag = currentState.editedTag else { return .empty() }

      var addedTagList = currentState.addedTagList
      var tagList = currentState.tagList

      if let index = addedTagList.firstIndex(of: editedTag) {
        addedTagList[index] = tag
      }

      if let index = tagList.firstIndex(of: editedTag) {
        tagList[index] = tag
      }

      return .concat([
        .just(Mutation.setAddedTagList(addedTagList)),
        .just(Mutation.setTagList(tagList)),
        .just(Mutation.setEditedTag(nil)),
      ])
    }
  }

  func removeAddedTag(at row: Int) -> Observable<Mutation> {
    var addedTagList = currentState.addedTagList

    addedTagList.remove(at: row)

    return .just(Mutation.setAddedTagList(addedTagList))
  }

  func removeTagListTag(at row: Int) -> Observable<Mutation> {
    var tagList = currentState.tagList

    tagList.remove(at: row)

    return .just(Mutation.setTagList(tagList))
  }

  func selectTag(at row: Int) -> Observable<Mutation> {
    var addedTagList = currentState.addedTagList
    let selectedTag = currentState.tagList[row]

    guard addedTagList.count < 10 else {
      return .just(Mutation.setShouldShowTagLimitToast)
    }

    if !addedTagList.contains(where: { $0 == selectedTag }) {
      addedTagList.append(selectedTag)
    }

    return .just(Mutation.setAddedTagList(addedTagList))
  }
}
