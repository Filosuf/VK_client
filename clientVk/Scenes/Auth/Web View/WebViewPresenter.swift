//
//  WebViewPresenter.swift
//  ClientVk
//
//  Created by Filosuf on 18.04.2023.
//

import Foundation

protocol WebViewPresenterProtocol {
    func decodingToken(with url: URL) -> Bool
}

final class WebViewPresenter: WebViewPresenterProtocol {
    // MARK: - Properties
    private let coordinator: AuthFlowCoordinator
    private let helper: AuthHelperProtocol
    private let tokenStorage: TokenStorageProtocol
    weak var delegate: WebViewControllerDelegate?

    // MARK: - Initialiser
    init(coordinator: AuthFlowCoordinator, helper: AuthHelperProtocol, tokenStorage: TokenStorageProtocol) {
        self.coordinator = coordinator
        self.helper = helper
        self.tokenStorage = tokenStorage
    }

    // MARK: - Methods
    func decodingToken(with url: URL) -> Bool {
        if let token = helper.code(from: url) {
            tokenStorage.saveToken(token)
            coordinator.pop()
            delegate?.didAuthenticate(with: token)
            return true
        }
        return false
    }
}
