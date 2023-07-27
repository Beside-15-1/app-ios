//
//  ManageTagViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import UIKit

import ReactorKit
import RxSwift

import DesignSystem

final class ManageTagViewController: UIViewController {

  // MARK: UI

  private lazy var contentView = ManageTagView()


  // MARK: Properties

  let reactor: ManageTagViewReactor

  var disposeBag = DisposeBag()


  // MARK: Initializing

  init(reactor: ManageTagViewReactor) {
    self.reactor = reactor
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView

    contentView.inputField.setDelegate(self)
    contentView.tagListView.delegate = self
    contentView.tagListView.editHandler = { [weak self] text in
      self?.contentView.inputField.becomeFirstResponder()
      self?.reactor.changeEditMode(text: text)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    bind(reactor: reactor)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.isNavigationBarHidden = false

    configureNavigationBar()
  }

  // MARK: Binding

  func bind(reactor: ManageTagViewReactor) {
    bindContent(with: reactor)
    bindButton(with: reactor)
  }

  private func bindContent(with viewModel: ManageTagViewReactor) {
    viewModel.localTagList
      .delay(.milliseconds(100), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] local in
        guard !local.isEmpty else { return }
        self?.contentView.tagListView.applyTagList(by: local)
      })
      .disposed(by: disposeBag)

    contentView.inputField.rx.text
      .subscribe(with: self) { `self`, text in
        self.reactor.inputText(text: text)
      }
      .disposed(by: disposeBag)

    viewModel.validatedText
      .bind(to: contentView.inputField.rx.text)
      .disposed(by: disposeBag)

    viewModel.shouldShowTagLimitToast
      .subscribe(with: self) { _, _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          PBToast(content: "태그는 10개까지 선택할 수 있어요")
            .show()
        }
      }
      .disposed(by: disposeBag)
  }

  private func bindButton(with viewModel: ManageTagViewReactor) {
    contentView.saveButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
  }
}


// MARK: - NavigationBar

extension ManageTagViewController {

  private func configureNavigationBar() {
    let backButton = UIBarButtonItem(
      image: DesignSystemAsset.iconPop.image.withTintColor(.staticBlack),
      style: .plain,
      target: self,
      action: #selector(pop)
    )

    navigationItem.leftBarButtonItem = backButton
    navigationItem.leftBarButtonItem?.tintColor = .staticBlack
    navigationItem.title = "태그 관리"

    let attributes = [
      NSAttributedString.Key.foregroundColor: UIColor.staticBlack,
      NSAttributedString.Key.font: UIFont.defaultRegular,
    ]
    navigationController?.navigationBar.titleTextAttributes = attributes
  }

  @objc
  private func pop() {
    navigationController?.popViewController(animated: true)
  }
}


// MARK: UITextFieldDelegate

extension ManageTagViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text,
          !text.isEmpty else {
      view.endEditing(true)
      return false
    }

    view.endEditing(true)
    textField.text = ""

    if reactor.tagInputMode == .input {
      reactor.addTag(text: text)
    } else {
      reactor.editTag(text: text)
    }

    return true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    reactor.editedTag = nil
    reactor.tagInputMode = .input
  }
}


// MARK: TagListViewDelegate

extension ManageTagViewController: TagListViewDelegate {
  func tagListView(_ tagListView: TagListView, didSelectedRow at: Int) {}

  func updateTagList(_ tagListView: TagListView, tagList: [String]) {
    reactor.localTagList.accept(tagList)
  }

  func removeTag(_ tagListView: TagListView, row at: Int) {
    reactor.removeTagListTag(at: at)
  }
}
