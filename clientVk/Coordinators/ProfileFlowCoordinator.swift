//
//  ProfileFlowCoordinator.swift
//  ClientVk
//
//  Created by Filosuf on 09.04.2023.
//

import UIKit

final class ProfileFlowCoordinator {

    // MARK: - Properties
    private let navCon: UINavigationController
    private let controllersFactory: ViewControllersFactory

    //MARK: - Initialiser
    init(navCon: UINavigationController, controllersFactory: ViewControllersFactory) {
        self.navCon = navCon
        self.controllersFactory = controllersFactory
    }

    // MARK: - Methods

    func switchToAuthController() {
        guard let window = UIApplication.shared.currentUIWindow() else { assertionFailure("Invalid Configuration"); return }
        window.rootViewController = controllersFactory.makeAuthViewController()
    }

    func showWebViewController() {
        let vc = controllersFactory.makeWebViewController()
        navCon.present(vc, animated: true)
    }
//    func showDeleteAlert(action: @escaping () -> Void) {
//        let alert = UIAlertController(
//            title: nil,
//            message: "Уверены, что хотите удалить трекер?",
//            preferredStyle: .actionSheet)
//
//        alert.view.accessibilityIdentifier = "error_alert"
//
//        let action = UIAlertAction(title: "Удалить", style: .destructive) { _ in
//            action()
//        }
//
//        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
//
//        alert.addAction(action)
//        alert.addAction(cancel)
//
//        navCon.present(alert, animated: true, completion: nil)
//    }
}
