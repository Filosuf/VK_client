//
//  MainCoordinator.swift
//  ClientVk
//
//  Created by Filosuf on 17.04.2023.
//

import UIKit


protocol MainCoordinator {
    func startApplication() -> UIViewController
    func switchToTabBarController()
}

final class MainCoordinatorImp: MainCoordinator {

    // MARK: - Properties
    private let controllersFactory: ViewControllersFactory
    private let tokenStorage: TokenStorageProtocol

    // MARK: - Initialiser
    init(controllersFactory: ViewControllersFactory, tokenStorage: TokenStorageProtocol) {
        self.controllersFactory = controllersFactory
        self.tokenStorage = tokenStorage
    }

    // MARK: - Methods
    func startApplication() -> UIViewController {
        if let token = tokenStorage.getToken(), token.isTokenValid {
            return controllersFactory.makeTabBarController()
        } else {
            let vc = controllersFactory.makeAuthViewController()
//            let navVC = UINavigationController(rootViewController: vc)
            return vc
        }
    }

    func switchToTabBarController() {
        // Получаем экземпляр `Window` приложения
        guard let window = UIApplication.shared.currentUIWindow() else { assertionFailure("Invalid Configuration"); return }
//        guard let window = UIApplication.shared.windows.first else { assertionFailure("Invalid Configuration"); return }
        window.rootViewController = controllersFactory.makeTabBarController()
    }

    //MARK: - Private methods
}
