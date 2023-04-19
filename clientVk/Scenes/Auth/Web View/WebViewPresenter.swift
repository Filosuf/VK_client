//
//  WebViewPresenter.swift
//  ClientVk
//
//  Created by Filosuf on 18.04.2023.
//

import Foundation

protocol WebViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func decodingToken(with url: URL) -> Bool
}

protocol WebViewControllerDelegate: AnyObject {
    func didAuthenticate(with: ApiToken)
}

final class WebViewPresenter: WebViewPresenterProtocol {
    // MARK: - Properties
    private let coordinator: AuthFlowCoordinator
    private let helper: AuthHelperProtocol
    private let tokenStorage: TokenStorageProtocol
    weak var delegate: WebViewControllerDelegate?
    weak var view: WebViewControllerProtocol?

    // MARK: - Initialiser
    init(coordinator: AuthFlowCoordinator, helper: AuthHelperProtocol, tokenStorage: TokenStorageProtocol) {
        self.coordinator = coordinator
        self.helper = helper
        self.tokenStorage = tokenStorage
    }

    // MARK: - Methods
    func viewDidLoad() {
        loadAutorizeScreen()
        didUpdateProgressValue(0)
    }

    private func loadAutorizeScreen() {
        let request = helper.authRequest()
        view?.load(request: request)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)

        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.1
    }

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
