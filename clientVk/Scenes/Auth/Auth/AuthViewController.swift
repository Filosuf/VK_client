//
//  AuthViewController.swift
//  ClientVk
//
//  Created by Filosuf on 11.04.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    // MARK: - Properties
    private let presenter: AuthViewPresenterProtocol
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("enter".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 34 / 2
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()

    // MARK: - Initialiser
    init(presenter: AuthViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
    }

    // MARK: - Methods
    @objc private func login() {
        presenter.loginHandle()
    }

    private func layout() {
        view.backgroundColor = .systemBackground
        [loginButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
}
