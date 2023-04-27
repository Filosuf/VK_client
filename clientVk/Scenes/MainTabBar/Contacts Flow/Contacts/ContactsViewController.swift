//
//  ContactsViewController.swift
//  ClientVk
//
//  Created by Filosuf on 19.04.2023.
//

import UIKit

protocol ContactsViewControllerProtocol: AnyObject {
    func updateView()
}

final class ContactsViewController: UIViewController, ContactsViewControllerProtocol {

    // MARK: - Properties
    private let presenter: ContactsViewPresenterProtocol

    private lazy var contactsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.identifier)
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    // MARK: - Initialiser
    init(presenter: ContactsViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "listOfFriends".localized
        view.backgroundColor = .systemBackground
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear()
    }

    // MARK: - Methods
    func updateView() {
        contactsTableView.reloadData()
    }

    private func layout() {
        [contactsTableView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        NSLayoutConstraint.activate([
            contactsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contactsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contactsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contactsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


// MARK: - UITableViewDataSource
extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier, for: indexPath) as! ContactsTableViewCell
        let profileVkontakte = presenter.friends[indexPath.row]
        let matchedContact = presenter.fetchContact(index: indexPath)
        cell.setupCell(iPhone: matchedContact, vkontakte: profileVkontakte)
        return cell
    }

}

// MARK: - UITableViewDelegate
extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(index: indexPath)
    }
}
