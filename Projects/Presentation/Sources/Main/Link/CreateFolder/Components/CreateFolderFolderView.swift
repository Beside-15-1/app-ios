import DesignSystem
import UIKit

class CreateFolderFolderView: UIView {
  // MARK: UI

  let inputField = InputField(type: .normal).then {
    $0.placeHolder = "폴더명을 입력해주세요."
    $0.title = "폴더명".styled(font: .subTitleSemiBold, color: .staticBlack)
    $0.returnKeyType = .done
  }

  // MARK: Life Cycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setView()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setView() {
    addSubview(inputField)
    inputField.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.height.equalTo(80)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }
  }
}
