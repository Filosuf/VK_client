//
//  WebViewController.swift
//  ClientVk
//
//  Created by Filosuf on 22.03.2023.
//

import UIKit
import WebKit


protocol WebViewControllerProtocol: AnyObject {
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewController: UIViewController, WebViewControllerProtocol {

    // MARK: - Properties
    private let presenter: WebViewPresenterProtocol
    private var progressView = UIProgressView()
    private var estimatedProgressObservation: NSKeyValueObservation?

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
        presenter.viewDidLoad()
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            estimatedProgressObservation = webView.observe(
                \.estimatedProgress,
                 options: [],
                 changeHandler: { [weak self] _, _ in
                     guard let self = self else { return }
                     self.presenter.didUpdateProgressValue(self.webView.estimatedProgress)
                 })
        }


    // MARK: - Methods
    func load(request: URLRequest) {
        webView.load(request)
    }

    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }

    private func layout() {
        view.backgroundColor = .systemBackground
        [progressView, webView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
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
