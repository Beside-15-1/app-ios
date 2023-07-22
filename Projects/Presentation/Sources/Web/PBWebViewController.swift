//
//  PBWebViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import Foundation
import UIKit
import WebKit

import SnapKit
import Then

class PBWebViewController: UIViewController {

  // MARK: UI

  lazy var webView = WKWebView().then {
    $0.navigationDelegate = self
  }

  let spinner = UIActivityIndicatorView(style: .large)


  // MARK: Properties

  let url: URL


  // MARK: Initialize

  init(url: URL) {
    self.url = url

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    defineLayout()

    let request = URLRequest(url: url)
    webView.load(request)
  }


  // MARK: Layout

  private func defineLayout() {
    view.addSubview(webView)
    view.addSubview(spinner)

    webView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    spinner.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}


extension PBWebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    // 웹뷰가 로딩을 시작할 때의 작업 처리
    spinner.startAnimating()
    spinner.isHidden = false
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    // 웹뷰 로딩이 완료된 후의 작업 처리
    spinner.stopAnimating()
    spinner.isHidden = true
  }
}
