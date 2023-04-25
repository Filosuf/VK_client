//
//  ContactsFlowCoordinator.swift
//  ClientVk
//
//  Created by Filosuf on 19.04.2023.
//

import UIKit
import ContactsUI

final class ContactsFlowCoordinator {
    // MARK: - Properties
    private let navCon: UINavigationController
    private let controllersFactory: ViewControllersFactory

    //MARK: - Initialiser
    init(navCon: UINavigationController, controllersFactory: ViewControllersFactory) {
        self.navCon = navCon
        self.controllersFactory = controllersFactory
    }

    // MARK: - Methods
    func showWebViewController() {
        let vc = controllersFactory.makeWebViewController()
        navCon.present(vc, animated: true)
    }

    func showContactDetailViewController(coordinator: ContactsFlowCoordinator, friend: Profile?, contact: Contact?) {
        let vc = controllersFactory.makeContactDetailsController(coordinator: coordinator, friend: friend, contact: contact)
        navCon.pushViewController(vc, animated: true)
    }
}
