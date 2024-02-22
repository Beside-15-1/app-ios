import Foundation

import ReactorKit
import RxSwift

import Domain

final class CreateFolderViewReactor: Reactor {

  enum Action {
    case updateTitle(String)
    case updateBackgroundColor(Int)
    case updateTitleColor(Int)
    case updateIllust(Int)
    case makeButtonTapped
  }

  enum Mutation {
    case updateFolder(Folder?)
    case updateViewModel(CreateFolderPreviewView.ViewModel)
    case setSucceed(Folder)
    case setError(String)
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
    let folderList: [Folder]

    var viewModel: CreateFolderPreviewView.ViewModel

    var isMakeButtonEnabled: Bool {
      !viewModel.title.isEmpty == true
    }

    var isSucceed: Folder?
    @Pulse var error: String?

    var isEdit: Bool {
      guard let _ = folder else {
        return false
      }

      return true
    }
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let createFolderUseCase: CreateFolderUseCase
  private let updateFolderUseCase: UpdateFolderUseCase
  private let getFolderListUseCase: GetFolderListUseCase

  // MARK: initializing

  init(
    createFolderUseCase: CreateFolderUseCase,
    updateFolderUseCase: UpdateFolderUseCase,
    getFolderListUseCase: GetFolderListUseCase,
    folder: Folder?
  ) {
    defer { _ = self.state }

    self.createFolderUseCase = createFolderUseCase
    self.updateFolderUseCase = updateFolderUseCase
    self.getFolderListUseCase = getFolderListUseCase

    var viewModel: CreateFolderPreviewView.ViewModel {
      guard let folder else {
        return .init(
          backgroundColor: "#91B0C4",
          titleColor: "#FFFFFF",
          title: "",
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
      folderList: getFolderListUseCase.execute().folders,
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
      var validatedTitle = title

      if title.count > 15 {
        validatedTitle = String(title.prefix(15))
      }

      folder?.title = validatedTitle

      var viewModel = currentState.viewModel
      viewModel.title = validatedTitle

      return .concat([
        .just(Mutation.updateFolder(folder)),
        .just(Mutation.updateViewModel(viewModel)),
      ])

    case .updateBackgroundColor(let index):
      var folder = currentState.folder
      folder?.backgroundColor = currentState.backgroundColors[index]

      var viewModel = currentState.viewModel
      viewModel.backgroundColor = currentState.backgroundColors[index]

      return .concat([
        .just(Mutation.updateFolder(folder)),
        .just(Mutation.updateViewModel(viewModel)),
      ])

    case .updateTitleColor(let index):
      var folder = currentState.folder
      folder?.titleColor = currentState.titleColors[index]

      var viewModel = currentState.viewModel
      viewModel.titleColor = currentState.titleColors[index]

      return .concat([
        .just(Mutation.updateFolder(folder)),
        .just(Mutation.updateViewModel(viewModel)),
      ])

    case .updateIllust(let row):
      var folder = currentState.folder
      folder?.illustration = "illust\(row)"

      var viewModel = currentState.viewModel
      viewModel.illuste = "illust\(row)"

      return .concat([
        .just(Mutation.updateFolder(folder)),
        .just(Mutation.updateViewModel(viewModel)),
      ])

    case .makeButtonTapped:
      guard let _ = currentState.folder else {
        return createFolder()
      }
      return updateFolder()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .updateFolder(let folder):
      newState.folder = folder

    case .updateViewModel(let viewModel):
      newState.viewModel = viewModel

    case .setSucceed(let folder):
      newState.isSucceed = folder

    case .setError(let error):
      newState.error = error
    }

    return newState
  }
}


extension CreateFolderViewReactor {

  private func createFolder() -> Observable<Mutation> {
    if currentState.folderList.contains(where: { $0.title == currentState.viewModel.title }) {
      return .just(Mutation.setError("같은 이름의 폴더가 존재합니다."))
    }

    return createFolderUseCase.execute(
      backgroundColor: currentState.viewModel.backgroundColor,
      title: currentState.viewModel.title.trimmingCharacters(in: .whitespacesAndNewlines),
      titleColor: currentState.viewModel.titleColor,
      illustration: currentState.viewModel.illuste
    )
    .asObservable()
    .flatMap { folder -> Observable<Mutation> in
      .just(Mutation.setSucceed(folder))
    }
  }

  private func updateFolder() -> Observable<Mutation> {
    return updateFolderUseCase.execute(
      id: currentState.folder?.id ?? "",
      backgroundColor: currentState.viewModel.backgroundColor,
      title: currentState.viewModel.title.trimmingCharacters(in: .whitespacesAndNewlines),
      titleColor: currentState.viewModel.titleColor,
      illustration: currentState.viewModel.illuste
    )
    .asObservable()
    .flatMap { folder -> Observable<Mutation> in
      .just(Mutation.setSucceed(folder))
    }
    .catch { _ in
      .just(Mutation.setError("같은 이름의 폴더가 존재합니다."))
    }
  }
}
