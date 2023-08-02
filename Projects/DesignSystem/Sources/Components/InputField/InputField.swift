//
//  InputField.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/06/05.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

public enum InputType {
  case normal
  case search
  case dropdown
}

public class InputField: UIView {

  // MARK: Properties

  public var placeHolder: String? {
    didSet {
      textField.placeholder = placeHolder
    }
  }

  public var title: NSAttributedString? {
    didSet {
      titleLabel.attributedText = title
      titleLabel.isHidden = false
    }
  }

  public var text: String? {
    get {
      textField.text
    }

    set {
      textField.text = newValue
    }
  }

  public var errorDescription: String? {
    didSet {
      errorLabel.text = errorDescription
    }
  }

  public var isEnabled = true {
    didSet {
      enabled(isEnabled: isEnabled)
    }
  }

  public var keyboardType: UIKeyboardType = .default {
    didSet {
      textField.keyboardType = keyboardType
    }
  }

  public var returnKeyType: UIReturnKeyType = .default {
    didSet {
      textField.returnKeyType = returnKeyType
    }
  }

  public override var tag: Int {
    didSet {
      textField.tag = tag
    }
  }

  public var textFieldInputView: UIView? {
    didSet {
      textField.inputView = textFieldInputView
    }
  }

  public var textFieldInputAccessoryView: UIView? {
    didSet {
      textField.inputAccessoryView = textFieldInputAccessoryView
    }
  }

  public var iconActionHandler: (()->Void)? = nil

  public func showError() {
    DispatchQueue.main.async {
      self.errorContainer.isHidden = false
    }
  }

  public func hideError() {
    DispatchQueue.main.async {
      self.errorContainer.isHidden = true
    }
  }

  public func setDelegate(_ delegate: UITextFieldDelegate) {
    textField.delegate = delegate
  }

  @discardableResult
  public override func becomeFirstResponder() -> Bool {
    textField.becomeFirstResponder()
  }

  @discardableResult
  public override func resignFirstResponder() -> Bool {
    textField.resignFirstResponder()
  }

  public func addAction(_ action: UIAction, for controlEvents: UIControl.Event) {
    textField.addAction(action, for: controlEvents)
  }

  public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
    textField.addTarget(target, action: action, for: controlEvents)
  }

  // MARK: UI

  private let stackView = UIStackView().then {
    $0.axis = .vertical
  }

  public let titleLabel = UILabel().then {
    $0.isHidden = true
    $0.font = .subTitleSemiBold
    $0.textColor = .gray900
  }

  private let container = UIControl().then {
    $0.backgroundColor = .gray200
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }

  let textField = UITextField().then {
    $0.font = .defaultRegular
    $0.textColor = .staticBlack
  }

  private let rightIcon = UIImageView().then {
    $0.isUserInteractionEnabled = true
  }

  private let errorContainer = UIView().then {
    $0.isHidden = true
  }

  private let errorLabel = UILabel().then {
    $0.textColor = .error
    $0.font = .captionRegular
  }

  private let errorIcon = UIImageView().then {
    $0.image = DesignSystemAsset.iconAlertCircleFill.image.withTintColor(.error)
  }

  // MARK: Initialize

  public convenience init(type: InputType) {
    self.init(frame: .zero)

    switch type {
    case .normal:
      textField.clearButtonMode = .whileEditing
      rightIcon.isHidden = true
      textField.snp.updateConstraints {
        $0.right.equalToSuperview().inset(12.0)
      }
    case .search:
      textField.clearButtonMode = .never
      rightIcon.image = DesignSystemAsset.iconSearchOutline.image.withTintColor(.gray500)
      rightIcon.isHidden = false
      textField.snp.updateConstraints {
        $0.right.equalToSuperview().inset(48.0)
      }

    case .dropdown:
      textField.clearButtonMode = .never
      rightIcon.image = DesignSystemAsset.iconDown.image.withTintColor(.gray500)
      rightIcon.isHidden = false
      textField.snp.updateConstraints {
        $0.right.equalToSuperview().inset(48.0)
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
    addAction()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func defineLayout() {
    addSubview(stackView)
    addSubview(errorContainer)

    [titleLabel, container].forEach { stackView.addArrangedSubview($0) }
    [textField, rightIcon].forEach { container.addSubview($0) }
    [errorIcon, errorLabel].forEach { errorContainer.addSubview($0) }

    stackView.setCustomSpacing(8.0, after: titleLabel)

    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    container.snp.makeConstraints {
      $0.height.equalTo(48.0)
    }

    textField.snp.makeConstraints {
      $0.left.equalToSuperview().inset(12.0)
      $0.right.equalToSuperview().inset(12.0)
      $0.centerY.equalToSuperview()
    }

    rightIcon.snp.makeConstraints {
      $0.size.equalTo(24.0)
      $0.right.equalToSuperview().inset(12.0)
      $0.centerY.equalToSuperview()
    }

    errorContainer.snp.makeConstraints {
      $0.top.equalTo(container.snp.bottom).offset(2.0)
      $0.left.right.equalToSuperview()
    }

    errorIcon.snp.makeConstraints {
      $0.left.equalToSuperview().inset(4.0)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(16.0)
    }

    errorLabel.snp.makeConstraints {
      $0.left.equalTo(errorIcon.snp.right).offset(4.0)
      $0.top.bottom.equalToSuperview()
    }
  }

  private func addAction() {
    rightIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(iconDidTap)))

    textField.addAction(UIAction(handler: { [weak self] _ in
      self?.textField.font = .defaultSemiBold
      self?.container.backgroundColor = .inputContainerEditing
      self?.container.layer.borderWidth = 1
      self?.rightIcon.image = self?.rightIcon.image?.withTintColor(.gray600)
    }), for: .editingDidBegin)

    textField.addAction(UIAction(handler: { [weak self] _ in
      self?.textField.font = .defaultRegular
      self?.container.backgroundColor = .gray200
      self?.container.layer.borderWidth = 0
      self?.rightIcon.image = self?.rightIcon.image?.withTintColor(.gray500)
    }), for: .editingDidEnd)
  }

  @objc
  private func iconDidTap() {
    iconActionHandler?()
  }

  private func enabled(isEnabled: Bool) {
    if isEnabled {
      isUserInteractionEnabled = true
      titleLabel.textColor = .gray400
      rightIcon.image = rightIcon.image?.withTintColor(.gray400)
    } else {
      isUserInteractionEnabled = false
      titleLabel.textColor = .gray500
      rightIcon.image = rightIcon.image?.withTintColor(.gray500)
    }
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    container.layer.borderColor = UIColor.inputActiveStroke.cgColor
  }
}


extension Reactive where Base: InputField {
  public var text: ControlProperty<String> {
    base.textField.rx.text.orEmpty
  }
}
