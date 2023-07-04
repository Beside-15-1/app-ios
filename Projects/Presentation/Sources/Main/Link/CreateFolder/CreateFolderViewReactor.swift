import Foundation

import RxSwift
import ReactorKit

import Domain

final class CreateFolderViewReactor: Reactor {

  enum Action {
    case updateTitle(String)
    case updateBackgroundColor(Int)
    case updateTitleColor(Int)
    case makeButtonTapped
  }

  enum Mutation {
    case updateFolder(Folder)
    case setSucceed
  }

  struct State {
    let backgroundColors = ["#91B0C4", "#FFFFB4", "#F5BAAA", "#FFD8BE", "#CABCD7", "#CCE2CB",
                            "#4D6776", "#F6B756", "#D56573", "#FF6854", "#A86EA0", "#748A7E"]
    let titleColors = ["#FFFFFF", "#000000"]

    var folder: Folder

    var isMakeButtonEnabled: Bool {
      return !folder.title.isEmpty
    }

    var isSuccess: Bool = false
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  // MARK: initializing

  init(
    folder: Folder = Folder(
      title: "제목을 입력하세요",
      backgroundColor: "#91B0C4",
      titleColor: "#FFFFFF",
      illustration: nil
      )
  ) {
    defer { _ = self.state }
    initialState = State(
      folder: folder
    )
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .updateTitle(let title):
      var folder = currentState.folder
      folder.title = title
      return .just(Mutation.updateFolder(folder))

    case .updateBackgroundColor(let index):
      var folder = currentState.folder
      folder.backgroundColor = currentState.backgroundColors[index]
      return .just(Mutation.updateFolder(folder))

    case .updateTitleColor(let index):
      var folder = currentState.folder
      folder.titleColor = currentState.titleColors[index]
      return .just(Mutation.updateFolder(folder))

    case .makeButtonTapped:
      // TODO: 링크북 생성
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .updateFolder(let folder):
      newState.folder = folder

    case .setSucceed:
      newState.isSuccess = true
    }

    return newState
  }
}
