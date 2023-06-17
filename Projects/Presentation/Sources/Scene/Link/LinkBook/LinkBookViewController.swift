//
//  LinkBookViewController.swift
//  PresentationInterface
//
//  Created by Hohyeon Moon on 2023/06/01.
//

import UIKit

import RxSwift

class LinkBookViewController: UIViewController {
  private let disposeBag = DisposeBag()

  private lazy var closeButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    button.setImage(UIImage(systemName: "xmark"), for: .normal)
    button.tintColor = .label
    return button
  }()

  private lazy var previewView = LinkBookPreviewView()

  private lazy var linkBookTabView = LinkBookTabView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .staticWhite

    setNavigation()
    setPreview()
    setTabView()

    bind()
  }

  private func setNavigation() {
    title = "새 폴더"
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)

    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.backgroundColor = .staticWhite
    navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    navigationController?.navigationBar.compactAppearance = navigationBarAppearance
    navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
  }

  private func setPreview() {
    view.addSubview(previewView)
    previewView.snp.makeConstraints { make in
      make.width.centerX.equalToSuperview()
      make.height.equalTo(260)
      make.top.equalTo(view.safeAreaLayoutGuide)
    }
  }

  private func setTabView() {
    view.addSubview(linkBookTabView)
    linkBookTabView.snp.makeConstraints { make in
      make.width.centerX.bottom.equalToSuperview()
      make.top.equalTo(previewView.snp.bottom)
    }
  }

  private func bind() {
    closeButton.rx.tap
      .subscribe(with: self) { _, _ in
        self.dismiss(animated: true)
      }
      .disposed(by: disposeBag)
  }
}
