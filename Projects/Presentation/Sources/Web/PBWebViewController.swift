//
//  PBWebViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import Foundation
import UIKit
import WebKit

class PBWebViewController: UIViewController {

  var webView: WKWebView!

  let url: URL

  init(url: URL) {
    self.url = url

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    webView = WKWebView(frame: view.bounds)
    view.addSubview(webView)

    let request = URLRequest(url: url)
    webView.load(request)
  }

}
