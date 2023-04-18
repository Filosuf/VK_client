//
//  ViewController.swift
//  ClientVk
//
//  Created by Filosuf on 22.03.2023.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    let tokenStorage: TokenStorageProtocol = TokenStorage()
    // MARK: - Initialiser

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
//        if let token = tokenStorage.getToken(), token.isTokenValid {
//            print("Token from storage")
//            let controllersFactory = ViewControllersFactory()
//            let coordinator = ProfileFlowCoordinator(navCon: UINavigationController(), controllersFactory: controllersFactory)
//            let profileService = ProfileService()
//            let tokenStorage = TokenStorage()
//            let presenter = ProfileViewPresenter(coordinator: coordinator, profileService: profileService, tokenStorage: tokenStorage)
//            let vc = ProfileViewController(presenter: presenter)
//            presenter.view = vc
//            navigationController?.pushViewController(vc, animated: true)
//        } else {
//            let controllersFactory = ViewControllersFactory()
//            let vc = controllersFactory.makeAuthViewController()
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }

    // MARK: - Methods
}

