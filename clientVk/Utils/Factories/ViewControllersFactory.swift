//
//  ViewControllersFactory.swift
//  ClientVk
//
//  Created by Filosuf on 10.04.2023.
//

import UIKit

final class ViewControllersFactory {

    // MARK: - Properties
    private let tokenStorage: TokenStorageProtocol
    private let authNavigationController = UINavigationController()
    private lazy var authFlowCoordinator = AuthFlowCoordinator(navCon: authNavigationController, controllersFactory: self)
    private let authHelper = AuthHelper()

    // MARK: - Initialiser
    init(tokenStorage: TokenStorageProtocol) {
        self.tokenStorage = tokenStorage
    }

    //MARK: - Trackers Flow
    func makeWebViewController(delegate: WebViewControllerDelegate? = nil) -> WebViewController {
        let presenter = WebViewPresenter(coordinator: authFlowCoordinator, helper: authHelper, tokenStorage: tokenStorage)
        presenter.delegate = delegate
        let viewController = WebViewController(presenter: presenter)
        return viewController
    }

    func makeAuthViewController() -> UIViewController {
        let presenter = AuthViewPresenter(coordinator: authFlowCoordinator)
        let viewController = AuthViewController(presenter: presenter)
        authNavigationController.pushViewController(viewController, animated: true)
        return authNavigationController
    }

    func makeTabBarController() -> UIViewController {
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.backgroundColor = .white

        let viewControllers = TabBarPage.allCases.map { getNavController(page: $0) }
        tabBarVC.setViewControllers(viewControllers, animated: true)
        return tabBarVC
    }

    private func getNavController(page: TabBarPage) -> UINavigationController {
        let navigationVC = UINavigationController()
        navigationVC.tabBarItem.image = page.image
        navigationVC.tabBarItem.title = page.pageTitle

        switch page {
        case .profile:
            let coordinator = ProfileFlowCoordinator(navCon: navigationVC, controllersFactory: self)
            let profileService = ProfileService()
            let presenter = ProfileViewPresenter(coordinator: coordinator, profileService: profileService, tokenStorage: tokenStorage)
            let profileVC = ProfileViewController(presenter: presenter)
            presenter.view = profileVC
            navigationVC.pushViewController(profileVC, animated: true)
        case .contacts:
//            let statsVC = controllersFactory.makeStatsViewController()
//            navigationVC.navigationBar.prefersLargeTitles = true
            let contactsVC = UIViewController()
            contactsVC.view.backgroundColor = .systemBlue
            navigationVC.pushViewController(contactsVC, animated: true)
        }

        return navigationVC
    }
}
