import UIKit

import RxSwift
import Then

import DesignSystem

class CreateFolderTabView: UIView {
  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: UI

  lazy var tabView = TabView().then {
    $0.applyTabs(by: ["폴더명", "컬러", "일러스트"])
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
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setViews() {
    addSubview(tabView)
    tabView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8)
      make.left.equalToSuperview().offset(20)
      make.right.equalToSuperview().offset(-20)
    }

    addSubview(folderView)
    folderView.snp.makeConstraints { make in
      make.top.equalTo(tabView.snp.bottom)
      make.bottom.equalToSuperview()
      make.width.centerX.equalToSuperview()
    }

    addSubview(colorView)
    colorView.snp.makeConstraints { make in
      make.top.equalTo(tabView.snp.bottom)
      make.bottom.equalToSuperview()
      make.width.centerX.equalToSuperview()
    }

    addSubview(illustView)
    illustView.snp.makeConstraints { make in
      make.top.equalTo(tabView.snp.bottom)
      make.bottom.equalToSuperview().offset(-108)
      make.width.centerX.equalToSuperview()
    }

    folderView.isHidden = false
    colorView.isHidden = true
    illustView.isHidden = true

    addSubview(makeButton)
    makeButton.snp.makeConstraints { make in
      make.width.equalToSuperview().offset(-40)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().offset(-40)
      make.height.equalTo(56)
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
        case "컬러":
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
