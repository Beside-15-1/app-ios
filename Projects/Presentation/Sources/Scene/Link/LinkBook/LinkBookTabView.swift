import UIKit

import Then

import DesignSystem

class LinkBookTabView: UIView {
  lazy var tabView = TabView().then {
    $0.applyTabs(by: ["폴더명", "컬러", "일러스트"])
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .staticWhite

    addSubview(tabView)
    tabView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8)
      make.left.equalToSuperview().offset(20)
      make.right.equalToSuperview().offset(-20)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
