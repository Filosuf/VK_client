//
//  AuthFlowCoordinator.swift
//  ClientVk
//
//  Created by Filosuf on 15.04.2023.
//

import UIKit

final class AuthFlowCoordinator {

    // MARK: - Properties
    private let navCon: UINavigationController
    private let controllersFactory: ViewControllersFactory

    //MARK: - Initialiser
    init(navCon: UINavigationController, controllersFactory: ViewControllersFactory) {
        self.navCon = navCon
        self.controllersFactory = controllersFactory
    }

    // MARK: - Methods

    func showWebViewController(delegate: WebViewControllerDelegate) {
        let vc = controllersFactory.makeWebViewController(delegate: delegate)
        navCon.pushViewController(vc, animated: true)
    }

    func switchToTabBarController() {
        // Получаем экземпляр `Window` приложения
        guard let window = UIApplication.shared.currentUIWindow() else { assertionFailure("Invalid Configuration"); return }
//        guard let window = UIApplication.shared.windows.first else { assertionFailure("Invalid Configuration"); return }
        window.rootViewController = controllersFactory.makeTabBarController()
    }

    func pop() {
        navCon.popViewController(animated: true)
    }

}
