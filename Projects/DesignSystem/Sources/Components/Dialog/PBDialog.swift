//
//  PBDialog.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/07/14.
//

import Foundation
import UIKit

import SnapKit
import Then

import PBLog

public class PBDialog: UIViewController {

  // MARK: UI

  private let dim = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.5)
  }

  private let shadowView = UIView()

  private let dialogView = UIView().then {
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
    $0.backgroundColor = .paperCard
    $0.alpha = 0
  }

  private let titleLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }

  private let contentLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }

  private let buttonStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 7
    $0.distribution = .fillEqually
  }

  let viewController: UIViewController

  public init(
    title: String,
    content: String,
    from viewController: UIViewController
  ) {
    titleLabel.attributedText = title.styled(font: .defaultSemiBold, color: .staticBlack)
    contentLabel.attributedText = content.styled(font: .defaultRegular, color: .staticBlack)
    self.viewController = viewController
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    PBLog.info("PBDialog Deinit")
  }


  public override func viewDidLoad() {
    super.viewDidLoad()

    defineLayout()
  }

  public func addAction(content: String, priority: ButtonPriority, action: (()->Void)?) -> PBDialog {
    let button = BasicButton(priority: priority).then {
      $0.text = content
    }

    buttonStackView.addArrangedSubview(button)
    button.addAction(UIAction(handler: { _ in
      self.dismiss(animated: true) {
        action?()
      }
    }), for: .touchUpInside)

    view.setNeedsLayout()

    return self
  }

  public func show() {
    modalTransitionStyle = .crossDissolve
    modalPresentationStyle = .overCurrentContext

    viewController.present(self, animated: false) {
      UIViewPropertyAnimator.runningPropertyAnimator(
        withDuration: 0.2,
        delay: 0,
        animations: {
          self.dialogView.alpha = 1
        }
      )
    }
  }

  private func defineLayout() {
    [dim, dialogView].forEach { view.addSubview($0) }

    [titleLabel, contentLabel, buttonStackView].forEach { dialogView.addSubview($0) }

    dim.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    dialogView.snp.makeConstraints {
      $0.width.equalTo(319.0)
      $0.center.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.left.right.equalToSuperview().inset(20.0)
    }

    contentLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(contentLabel.snp.bottom).offset(20.0)
      $0.left.bottom.right.equalToSuperview().inset(20.0)
      $0.height.equalTo(56.0)
    }
  }
}
