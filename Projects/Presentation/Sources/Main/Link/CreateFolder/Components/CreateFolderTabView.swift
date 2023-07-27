import UIKit

import RxSwift
import Then

import DesignSystem

class CreateFolderTabView: UIView {
  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: UI

  lazy var tabView = PrimaryTabView().then {
    $0.applyTabs(by: ["폴더명", "색상", "일러스트"])
  }

  lazy var folderView = CreateFolderFolderView()
  lazy var colorView = CreateFolderColorView()
  lazy var illustView = CreateFolderIllustView()

  let makeButton = BasicButton(priority: .primary).then {
    $0.text = "만들기"
  }

  // MARK: Life Cycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .staticWhite

    setViews()
    bind()

    tabView.selectItem(at: 0)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setViews() {
    addSubview(tabView)
    addSubview(folderView)
    addSubview(colorView)
    addSubview(illustView)
    addSubview(makeButton)
    tabView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8)
      make.left.right.equalToSuperview()
    }

    folderView.snp.makeConstraints { make in
      make.top.equalTo(tabView.snp.bottom)
      make.bottom.equalTo(makeButton.snp.top).offset(-12.0)
      make.width.centerX.equalToSuperview()
    }

    colorView.snp.makeConstraints { make in
      make.top.equalTo(tabView.snp.bottom)
      make.bottom.equalTo(makeButton.snp.top).offset(-12.0)
      make.width.centerX.equalToSuperview()
    }

    illustView.snp.makeConstraints { make in
      make.top.equalTo(tabView.snp.bottom)
      make.bottom.equalTo(makeButton.snp.top).offset(-12.0)
      make.width.centerX.equalToSuperview()
    }

    folderView.isHidden = false
    colorView.isHidden = true
    illustView.isHidden = true

    makeButton.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(20.0)
      make.bottom.equalTo(safeAreaLayoutGuide).inset(20.0)
    }
  }

  private func bind() {
    tabView.selectedTab
      .subscribe { [weak self] tab in
        switch tab.element {
        case "폴더명":
          self?.folderView.isHidden = false
          self?.colorView.isHidden = true
          self?.illustView.isHidden = true
        case "색상":
          self?.folderView.isHidden = true
          self?.colorView.isHidden = false
          self?.illustView.isHidden = true
        case "일러스트":
          self?.folderView.isHidden = true
          self?.colorView.isHidden = true
          self?.illustView.isHidden = false
        default:
          self?.folderView.isHidden = true
          self?.colorView.isHidden = true
          self?.illustView.isHidden = true
        }
      }
      .disposed(by: disposeBag)
  }
}
