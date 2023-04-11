//
//  WebViewController.swift
//  ClientVk
//
//  Created by Filosuf on 22.03.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    // MARK: - Properties
    let helper = AuthHelper()
    let tokenStorage: TokenStorageProtocol = TokenStorage()

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = webView
        let helper = AuthHelper()
        let request = helper.authRequest()
        webView.load(request)
    }
    // MARK: - Methods
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            tokenStorage.saveToken(code)
            navigationController?.popViewController(animated: true)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func code(from navigationAction: WKNavigationAction) -> ApiToken? {
        if let url = navigationAction.request.url {
            return helper.code(from: url)
        }
        return nil
    }

//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        guard let url = webView.url, let token = helper.code(from: url) else { return }
//        tokenStorage.saveToken(token)
//    }
}
