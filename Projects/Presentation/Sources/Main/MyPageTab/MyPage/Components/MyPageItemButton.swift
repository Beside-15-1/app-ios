//
//  MyPageItemButton.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/20.
//

import UIKit

import SnapKit
import Then

import DesignSystem
import PBUserDefaults

enum MyPageItemType {
  case tag
  case theme

  case sign

  case service
  case security
  case version

  case logout
}

final class MyPageItemButton: UIControl {

  // MARK: UI

  let container = UIView().then {
    $0.isUserInteractionEnabled = false
  }

  let leftIcon = UIImageView().then {
    $0.isHidden = true
  }

  let titleLabel = UILabel().then {
    $0.isHidden = true
  }

  let rightIcon = UIImageView().then {
    $0.isHidden = true
  }

  let subTitleLabel = UILabel().then {
    $0.isHidden = true
  }

  let versionLabel = UILabel().then {
    $0.isHidden = true
  }

  // MARK: Properties

  override var isHighlighted: Bool {
    didSet {
      runHighlightAnimation()
    }
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .paperWhite
    self.clipsToBounds = true

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configure(type: MyPageItemType) {
    switch type {
    case .tag:
      leftIcon.image = DesignSystemAsset.iconHash.image.withTintColor(.gray900)
      titleLabel.attributedText = "태그 관리".styled(font: .defaultBold, color: .gray900)
      rightIcon.image = DesignSystemAsset.iconRight.image.withTintColor(.gray900)
      leftIcon.isHidden = false
      titleLabel.isHidden = false
      rightIcon.isHidden = false

    case .theme:
      leftIcon.image = DesignSystemAsset.iconSun.image.withTintColor(.gray900)
      titleLabel.attributedText = "테마 관리".styled(font: .defaultBold, color: .gray900)
      rightIcon.image = DesignSystemAsset.iconRight.image.withTintColor(.gray900)
      leftIcon.isHidden = false
      titleLabel.isHidden = false
      rightIcon.isHidden = false

    case .sign:
      leftIcon.image = DesignSystemAsset.iconPersonOutline.image.withTintColor(.gray900)
      titleLabel.attributedText = UserDefaultsManager.shared.social
        .styled(font: .defaultBold, color: .gray900)
      rightIcon.image = DesignSystemAsset.iconRight.image.withTintColor(.gray900)
      subTitleLabel.attributedText = UserDefaultsManager.shared.email
        .styled(font: .bodyRegular, color: .gray700)
      leftIcon.isHidden = false
      titleLabel.isHidden = false
      rightIcon.isHidden = false
      subTitleLabel.isHidden = false

      addSubview(subTitleLabel)
      container.snp.remakeConstraints {
        $0.left.right.equalToSuperview().inset(20.0)
        $0.top.bottom.equalToSuperview()
        $0.height.equalTo(90.0)
      }
      leftIcon.snp.remakeConstraints {
        $0.left.equalToSuperview()
        $0.top.equalToSuperview().inset(20.0)
        $0.size.equalTo(24.0)
      }
      titleLabel.snp.remakeConstraints {
        $0.left.equalTo(leftIcon.snp.right).offset(8.0)
        $0.centerY.equalTo(leftIcon)
      }
      rightIcon.snp.remakeConstraints {
        $0.right.equalToSuperview()
        $0.centerY.equalTo(leftIcon)
        $0.size.equalTo(24.0)
      }
      subTitleLabel.snp.remakeConstraints {
        $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
        $0.left.equalTo(titleLabel)
      }

    case .service:
      leftIcon.image = DesignSystemAsset.iconFileCheck.image.withTintColor(.gray900)
      titleLabel.attributedText = "서비스 이용약관".styled(font: .defaultBold, color: .gray900)
      rightIcon.image = DesignSystemAsset.iconRight.image.withTintColor(.gray900)
      leftIcon.isHidden = false
      titleLabel.isHidden = false
      rightIcon.isHidden = false

    case .security:
      leftIcon.image = DesignSystemAsset.iconFolderLock.image.withTintColor(.gray900)
      titleLabel.attributedText = "개인정보 처리방침".styled(font: .defaultBold, color: .gray900)
      rightIcon.image = DesignSystemAsset.iconRight.image.withTintColor(.gray900)
      leftIcon.isHidden = false
      titleLabel.isHidden = false
      rightIcon.isHidden = false

    case .version:
      leftIcon.image = DesignSystemAsset.iconAlertCircleOutline.image.withTintColor(.gray900)
      titleLabel.attributedText = "버전 정보".styled(font: .defaultBold, color: .gray900)
      getVersionText()
      leftIcon.isHidden = false
      titleLabel.isHidden = false
      versionLabel.isHidden = false

    case .logout:
      titleLabel.attributedText = "로그아웃".styled(font: .defaultBold, color: .gray900)
      rightIcon.image = DesignSystemAsset.iconExit.image.withTintColor(.gray900)
      titleLabel.isHidden = false
      rightIcon.isHidden = false
      titleLabel.snp.remakeConstraints {
        $0.left.centerY.equalToSuperview()
      }
    }
    setNeedsLayout()
  }


//  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    super.touchesBegan(touches, with: event)
//    isHighlighted = true
//  }
//
//  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    super.touchesEnded(touches, with: event)
//    isHighlighted = false
//  }

  // MARK: Animation

  private func runHighlightAnimation() {
    UIViewPropertyAnimator.runningPropertyAnimator(
      withDuration: 0.1,
      delay: 0,
      animations: {
        self.backgroundColor = self.isHighlighted ? .gray100 : .paperWhite
        self.transform = self.isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
        self.layer.cornerRadius = self.isHighlighted ? 8 : 0
      }
    )
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(container)
    [leftIcon, titleLabel, rightIcon, versionLabel].forEach {
      container.addSubview($0)
    }

    container.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20.0)
      $0.top.bottom.equalToSuperview()
      $0.height.equalTo(64.0)
    }

    leftIcon.snp.makeConstraints {
      $0.left.centerY.equalToSuperview()
      $0.size.equalTo(24.0)
    }

    titleLabel.snp.makeConstraints {
      $0.left.equalTo(leftIcon.snp.right).offset(8.0)
      $0.centerY.equalToSuperview()
    }

    rightIcon.snp.makeConstraints {
      $0.right.centerY.equalToSuperview()
    }

    versionLabel.snp.makeConstraints {
      $0.right.centerY.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }

  private func getVersionText() {
    // URL 생성
    guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=com.pinkboss.joosum") else {
      let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
      versionLabel.attributedText = "현재\(currentVersion ?? "버전을 불러오는데 실패했어요")"
        .styled(font: .bodyRegular, color: .gray700)
        .underLine(target: currentVersion ?? "버전을 불러오는데 실패했어요")
      return
    }

    // URLSession을 사용하여 비동기적으로 데이터를 가져오는 데이터 태스크 생성
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data,
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json["results"] as? [[String: Any]],
            results.count > 0,
            let appStoreVersion = results[0]["version"] as? String,
            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        DispatchQueue.main.async {
          self.versionLabel.attributedText = "현재\(currentVersion ?? "버전을 불러오는데 실패했어요")"
            .styled(font: .bodyRegular, color: .gray700)
            .underLine(target: currentVersion ?? "버전을 불러오는데 실패했어요")
        }

        return
      }

      // 가져온 데이터를 처리하고 버전을 비교합니다
      DispatchQueue.main.async {
        self.versionLabel.attributedText = "현재\(currentVersion) / 최신\(appStoreVersion)"
          .styled(font: .bodyRegular, color: .gray600)
          .underLine(target: currentVersion)
          .color(color: .gray700, target: "현재\(currentVersion)")
      }
    }

    // 데이터 태스크 실행
    task.resume()
  }
}
