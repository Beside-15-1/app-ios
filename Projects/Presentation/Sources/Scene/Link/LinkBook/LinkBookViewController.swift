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

  let previewView = LinkBookPreviewView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    setNavigationBar()
    setPreview()
    bind()
  }

  func setNavigationBar() {
    title = "새 폴더"
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)

    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.backgroundColor = .systemBackground
    navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    navigationController?.navigationBar.compactAppearance = navigationBarAppearance
    navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
  }

  func setPreview() {
    view.addSubview(previewView)
    previewView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.centerX.equalToSuperview()
      make.height.equalTo(260)
      make.top.equalToSuperview()
    }
  }

  func bind() {
    closeButton.rx.tap
      .subscribe(with: self) { _, _ in
        self.dismiss(animated: true)
      }
      .disposed(by: disposeBag)
  }
}
