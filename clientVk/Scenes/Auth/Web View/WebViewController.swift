//
//  WebViewController.swift
//  ClientVk
//
//  Created by Filosuf on 22.03.2023.
//

import UIKit
import WebKit
protocol WebViewControllerDelegate: AnyObject {
    func didAuthenticate(with token: ApiToken)
}

final class WebViewController: UIViewController {
    // MARK: - Properties
    private let presenter: WebViewPresenterProtocol

    let helper = AuthHelper()
    let tokenStorage: TokenStorageProtocol = TokenStorage()

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()

    // MARK: - Initialiser
    init(presenter: WebViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        if let url = navigationAction.request.url, presenter.decodingToken(with: url) {
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
