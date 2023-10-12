import Foundation
import UIKit

import AuthenticationServices
import FlexLayout
import PinLayout
import SnapKit
import Then

import DesignSystem

// MARK: - LoginView

class LoginView: UIView {
  // MARK: Constants

  private enum Metric {
    static let joosume = CGSize(width: 140.0, height: 105.0)
    static let appleLogo = CGSize(width: 18.0, height: 18.0)
    static let googleLogo = CGSize(width: 18.0, height: 18.0)
  }

  // MARK: UI

  private let flexContainer = UIView()

  private let imageJoosum = UIImageView().then {
    $0.image = DesignSystemAsset.imgLoginJoosume.image.withTintColor(.white)
  }

  private let logoLabel = UILabel().then {
    $0.attributedText = "JOOSUM".styled(font: .logo, color: .white)
  }

  private let subTitleLabel = UILabel().then {
    $0.attributedText = "링크를 주섬주섬 담아\n나만의 책장을 만들어요".styled(
      font: .subTitleRegular,
      color: .primary100)
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }

  let googleButton = UIControl().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 4
  }

  private let googleIcon = UIImageView().then {
    $0.image = DesignSystemAsset.googleIcon.image
  }

  private let googleLabel = UILabel().then {
    $0.attributedText = "구글 계정으로 로그인".styled(
      font: .systemFont(ofSize: 14, weight: .regular),
      color: .black.withAlphaComponent(0.54))
  }

  let appleButton = UIControl().then {
    $0.backgroundColor = .black
    $0.layer.cornerRadius = 4
  }

  private let appleIcon = UIImageView().then {
    $0.image = DesignSystemAsset.appleIcon.image
  }

  private let appleLabel = UILabel().then {
    $0.attributedText = "Apple로 로그인".styled(
      font: .systemFont(ofSize: 14, weight: .regular),
      color: .white)
  }

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = UIColor(hexString: "#392A95")

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: Layout

  private func defineLayout() {
    addSubview(flexContainer)

    flexContainer.flex
      .justifyContent(.center)
      .paddingHorizontal(20.0)
      .define { flex in

        // Top
        flex.addItem()
          .grow(1.0)
          .justifyContent(.center)
          .alignItems(.center)
          .define { flex in
            flex.addItem(imageJoosum)
              .size(Metric.joosume)

            flex.addItem(logoLabel)

            flex.addItem(subTitleLabel)
              .shrink(1.0)
              .marginTop(20.0)
          }

        // Bottom
        flex.addItem()
          .shrink(1.0)
          .width(100%)
          .marginBottom(144.0)
          .define { flex in
            flex.addItem(appleButton)
              .marginBottom(12.0)
              .height(40.0)
              .justifyContent(.center)
              .alignItems(.center)
              .direction(.row)
              .define { flex in
                flex.addItem(appleIcon)
                  .size(Metric.appleLogo)

                flex.addItem(appleLabel)
                  .marginStart(8.0)
              }

            flex.addItem(googleButton)
              .height(40.0)
              .justifyContent(.center)
              .alignItems(.center)
              .direction(.row)
              .define { flex in
                flex.addItem(googleIcon)
                  .size(Metric.googleLogo)

                flex.addItem(googleLabel)
                  .marginStart(8.0)
              }
          }
      }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    flexContainer.pin.all(pin.safeArea)
    flexContainer.flex.layout()
  }
}
