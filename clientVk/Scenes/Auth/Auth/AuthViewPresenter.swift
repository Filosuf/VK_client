//
//  AuthViewPresenter.swift
//  ClientVk
//
//  Created by Filosuf on 15.04.2023.
//

import Foundation

protocol AuthViewPresenterProtocol {
    func loginHandle()
}

final class AuthViewPresenter: AuthViewPresenterProtocol {
    // MARK: - Properties
    private let coordinator: AuthFlowCoordinator

    // MARK: - Initialiser
    init(coordinator: AuthFlowCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Methods
    func loginHandle() {
        coordinator.showWebViewController(delegate: self)
    }
}

extension AuthViewPresenter: WebViewControllerDelegate {
    func didAuthenticate(with token: ApiToken) {
        coordinator.switchToTabBarController()
    }
}
