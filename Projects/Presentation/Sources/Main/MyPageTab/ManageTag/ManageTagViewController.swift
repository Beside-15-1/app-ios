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
import PBAnalyticsInterface

final class ManageTagViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = ManageTagView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let analytics: PBAnalytics


  // MARK: Initializing

  init(
    reactor: ManageTagViewReactor,
    analytics: PBAnalytics
  ) {
    defer { self.reactor = reactor }

    self.analytics = analytics

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
      self?.reactor?.action.onNext(.editButtonTapped(text))
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    reactor?.action.onNext(.viewDidLoad)

    navigationController?.interactivePopGestureRecognizer?.delegate = nil
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.isNavigationBarHidden = false

    configureNavigationBar()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    analytics.log(type: SettingTagEvent.shown)
  }

  // MARK: Binding

  func bind(reactor: ManageTagViewReactor) {
    bindContent(with: reactor)
    bindButton(with: reactor)
  }

  private func bindContent(with reactor: ManageTagViewReactor) {
    reactor.state.map(\.tagList)
      .distinctUntilChanged()
      .do(onNext: { _ in
        reactor.action.onNext(.syncTagList)
      })
      .subscribe(onNext: { [weak self] tagList in
        guard !tagList.isEmpty else { return }

        let items = tagList.map { tag in TagListSection.Item.normal(tag) }
        self?.contentView.tagListView.applyTagList(by: items)
      })
      .disposed(by: disposeBag)

    contentView.inputField.rx.text
      .subscribe(with: self) { `self`, text in
        self.reactor?.action.onNext(.inputText(text))
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.validatedText)
      .distinctUntilChanged()
      .bind(to: contentView.inputField.rx.text)
      .disposed(by: disposeBag)

    contentView.inputField.rx.editingDidBegin
      .subscribe(with: self) { `self`, _ in
        self.analytics.log(type: SettingTagEvent.click(component: .inputbox))
      }
      .disposed(by: disposeBag)
  }

  private func bindButton(with viewModel: ManageTagViewReactor) {
    contentView.saveButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.analytics.log(type: SettingTagEvent.click(component: .saveTag))
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
      NSAttributedString.Key.font: UIFont.titleBold,
    ]
    navigationController?.navigationBar.titleTextAttributes = attributes
  }

  @objc
  private func pop() {
    self.analytics.log(type: SettingTagEvent.click(component: .back))
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

    reactor?.action.onNext(.returnButtonTapped(text))

    return true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    reactor?.action.onNext(.endEditing)
  }
}


// MARK: TagListViewDelegate

extension ManageTagViewController: TagListViewDelegate {
  func tagListView(_ tagListView: TagListView, didSelectedRow at: Int) {}

  func updateTagList(_ tagListView: TagListView, tagList: [String]) {
    reactor?.action.onNext(.replaceTagOrder(tagList))
  }

  func removeTag(_ tagListView: TagListView, row at: Int) {
    reactor?.action.onNext(.tagListTagRemoveButtonTapped(at: at))
  }
}
