//
//  ProfileViewPresenter.swift
//  ClientVk
//
//  Created by Filosuf on 10.04.2023.
//

import Foundation
import WebKit

protocol ProfileViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func logout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - Properties
    weak var view: ProfileViewControllerProtocol?

    let coordinator: ProfileFlowCoordinator
    let profileService: ProfileServiceProtocol
    let tokenStorage: TokenStorageProtocol
    
    // MARK: - Initialiser
    init(coordinator: ProfileFlowCoordinator, profileService: ProfileServiceProtocol, tokenStorage: TokenStorageProtocol) {
        self.coordinator = coordinator
        self.profileService = profileService
        self.tokenStorage = tokenStorage
    }

    // MARK: - Methods
    func viewDidLoad() {
        checkingToken()
    }

    func logout() {
        tokenStorage.removeToken()
        cleanCookie()
        coordinator.switchToAuthController()
    }

    // MARK: - Private methods
    private func checkingToken() {
        if let token = tokenStorage.getToken(), token.isTokenValid {
            profileService.fetchProfile(token.accessToken) { [weak self] result in
                switch result {
                case .success(let profiles):
                    guard let profileResponse = profiles.first else { return }
                    let profile = Profile(profile: profileResponse)
                    self?.view?.setupView(profile: profile)
                case .failure(_):
                    return
                }
            }
        } else {
            coordinator.showWebViewController()
        }
    }

    private func cleanCookie() {
        // Очищаем все куки из хранилища.
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
