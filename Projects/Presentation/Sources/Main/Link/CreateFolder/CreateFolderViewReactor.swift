import Foundation

import ReactorKit
import RxSwift

import Domain

final class CreateFolderViewReactor: Reactor {

  enum Action {
    case updateTitle(String)
    case updateBackgroundColor(Int)
    case updateTitleColor(Int)
    case makeButtonTapped
  }

  enum Mutation {
    case updateFolder(Folder?)
    case updateViewModel(CreateFolderPreviewView.ViewModel)
    case setSucceed
  }

  struct State {
    let backgroundColors = [
      "#91B0C4",
      "#FFFFB4",
      "#F5BAAA",
      "#FFD8BE",
      "#CABCD7",
      "#CCE2CB",
      "#4D6776",
      "#F6B756",
      "#D56573",
      "#FF6854",
      "#A86EA0",
      "#748A7E",
    ]
    let titleColors = ["#FFFFFF", "#000000"]

    var folder: Folder?

    var viewModel: CreateFolderPreviewView.ViewModel

    var isMakeButtonEnabled: Bool {
      !viewModel.title.isEmpty == true
    }

    var isSuccess = false
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let createFolderUseCase: CreateFolderUseCase

  // MARK: initializing

  init(
    createFolderUseCase: CreateFolderUseCase,
    folder: Folder?
  ) {
    defer { _ = self.state }

    self.createFolderUseCase = createFolderUseCase

    var viewModel: CreateFolderPreviewView.ViewModel {
      guard let folder else {
        return .init(
          backgroundColor: "#91B0C4",
          titleColor: "#FFFFFF",
          title: "제목을 입력해주세요",
          illuste: nil
        )
      }

      return .init(
        backgroundColor: folder.backgroundColor,
        titleColor: folder.titleColor,
        title: folder.title,
        illuste: folder.illustration
      )
    }

    self.initialState = State(
      folder: folder,
      viewModel: viewModel
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
      folder?.title = title

      var viewModel = currentState.viewModel
      viewModel.title = title

      return .concat([
        .just(Mutation.updateFolder(folder)),
        .just(Mutation.updateViewModel(viewModel))
      ])

    case .updateBackgroundColor(let index):
      var folder = currentState.folder
      folder?.backgroundColor = currentState.backgroundColors[index]

      var viewModel = currentState.viewModel
      viewModel.backgroundColor = currentState.backgroundColors[index]

      return .concat([
        .just(Mutation.updateFolder(folder)),
        .just(Mutation.updateViewModel(viewModel))
      ])

    case .updateTitleColor(let index):
      var folder = currentState.folder
      folder?.titleColor = currentState.titleColors[index]
      
      var viewModel = currentState.viewModel
      viewModel.titleColor = currentState.titleColors[index]

      return .concat([
        .just(Mutation.updateFolder(folder)),
        .just(Mutation.updateViewModel(viewModel))
      ])

    case .makeButtonTapped:
      guard let folder = currentState.folder else {
        // TODO: 새로운 링크북 생성
        return createFolder()
      }
      // TODO: 기존 링크북 업데이트
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .updateFolder(let folder):
      newState.folder = folder

    case .updateViewModel(let viewModel):
      newState.viewModel = viewModel

    case .setSucceed:
      newState.isSuccess = true
    }

    return newState
  }
}


extension CreateFolderViewReactor {

  private func createFolder() -> Observable<Mutation> {
    createFolderUseCase.execute(
      backgroundColor: currentState.viewModel.backgroundColor,
      title: currentState.viewModel.title,
      titleColor: currentState.viewModel.titleColor,
      illustration: currentState.viewModel.illuste
    )
    .asObservable()
    .flatMap { _ -> Observable<Mutation> in
      return .just(Mutation.setSucceed)
    }
  }
}
