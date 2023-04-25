//
//  ContactsViewPresenter.swift
//  ClientVk
//
//  Created by Filosuf on 19.04.2023.
//

import Foundation

protocol ContactsViewPresenterProtocol: AnyObject {
    var friends: [Profile] { get }
    var contacts: [Contact] { get }
    func viewDidLoad()
    func fetchContact(index: IndexPath) -> Contact?
    func didSelectRow(index: IndexPath)
}

final class ContactsViewPresenter: ContactsViewPresenterProtocol {
    // MARK: - Properties
    weak var view: ContactsViewControllerProtocol?

    let coordinator: ContactsFlowCoordinator
    let friendsService: FriendsServiceProtocol
    let contactsService: ContactsServiceProtocol
    let tokenStorage: TokenStorageProtocol

    var friends: [Profile] = []
    var contacts: [Contact] = []

    // MARK: - Initialiser
    init(coordinator: ContactsFlowCoordinator, friendsService: FriendsServiceProtocol, contactsService: ContactsServiceProtocol ,tokenStorage: TokenStorageProtocol) {
        self.coordinator = coordinator
        self.friendsService = friendsService
        self.contactsService = contactsService
        self.tokenStorage = tokenStorage
    }

    // MARK: - Methods
    func viewDidLoad() {
        checkingToken()
        contacts = contactsService.getPhoneContacts()
    }

    func fetchContact(index: IndexPath) -> Contact? {
        let friendPhoneNumber = friends[index.row].mobilePhone?.shortPhoneNumber()
        return contacts.first(where: { $0.mobilePhone?.shortPhoneNumber() == friendPhoneNumber && friendPhoneNumber != nil})
    }

    func didSelectRow(index: IndexPath) {
        let friend = friends[index.row]
        let contact = fetchContact(index: index)
        coordinator.showContactDetailViewController(coordinator: coordinator, friend: friend, contact: contact)
    }

    // MARK: - Private methods
    private func checkingToken() {
        if let token = tokenStorage.getToken(), token.isTokenValid {
            friendsService.fetchProfile(token.accessToken) { [weak self] result in
                switch result {
                case .success(let profiles):
                    self?.friends = profiles.map { Profile(profile: $0) }
                    self?.view?.updateView()
                case .failure(_):
                    return
                }
            }
        } else {
            coordinator.showWebViewController()
        }
    }
}
