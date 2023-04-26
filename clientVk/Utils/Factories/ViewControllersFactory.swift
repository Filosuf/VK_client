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
    let contactsService = ContactsService()

    // MARK: - Initialiser
    init(tokenStorage: TokenStorageProtocol) {
        self.tokenStorage = tokenStorage
    }

    //MARK: - Trackers Flow
    func makeWebViewController(delegate: WebViewControllerDelegate? = nil) -> WebViewController {
        let presenter = WebViewPresenter(coordinator: authFlowCoordinator, helper: authHelper, tokenStorage: tokenStorage)
        presenter.delegate = delegate
        let viewController = WebViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }

    func makeAuthViewController() -> UIViewController {
        let presenter = AuthViewPresenter(coordinator: authFlowCoordinator)
        let viewController = AuthViewController(presenter: presenter)
        authNavigationController.pushViewController(viewController, animated: true)
        return authNavigationController
    }

    func makeContactDetailsController(coordinator: ContactsFlowCoordinator, friend: Profile?, contact: Contact?) -> ContactDetailsViewController {
        let presenter = ContactDetailsViewPresenter(coordinator: coordinator,contactService: contactsService, friend: friend, contact: contact)
        let contactDetailsVC = ContactDetailsViewController(presenter: presenter)
        presenter.view = contactDetailsVC
        return contactDetailsVC
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
            let coordinator = ContactsFlowCoordinator(navCon: navigationVC, controllersFactory: self)
            let friendsService = FriendsService()
            let presenter = ContactsViewPresenter(coordinator: coordinator, friendsService: friendsService, contactsService: contactsService, tokenStorage: tokenStorage)
            let contactsVC = ContactsViewController(presenter: presenter)
            presenter.view = contactsVC
            navigationVC.pushViewController(contactsVC, animated: true)
            return navigationVC
        }

        return navigationVC
    }
}
