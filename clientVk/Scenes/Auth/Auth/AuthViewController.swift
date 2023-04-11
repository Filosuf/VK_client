//
//  AuthViewController.swift
//  ClientVk
//
//  Created by Filosuf on 11.04.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: AuthViewControllerDelegate?


    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//extension AuthViewController: WebViewViewControllerDelegate {
//    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
//        delegate?.authViewController(self, didAuthenticateWithCode: code)
//    }
//
//    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
//        dismiss(animated: true)
//    }
//}
