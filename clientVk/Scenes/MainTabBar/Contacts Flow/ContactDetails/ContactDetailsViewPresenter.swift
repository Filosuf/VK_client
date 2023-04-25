//
//  ContactDetailsViewPresenter.swift
//  ClientVk
//
//  Created by Filosuf on 21.04.2023.
//

import Foundation

protocol ContactsDetailsViewPresenterProtocol: AnyObject {
    func updatePhoto()
}

final class ContactsDetailsViewPresenter: ContactsDetailsViewPresenterProtocol {
    // MARK: - Properties
    weak var view: ContactsDetailsViewControllerProtocol?

    let coordinator: ContactsFlowCoordinator
    let contactsService: ContactsServiceProtocol

    var friend: Profile?
    var contact: Contact?

    // MARK: - Initialiser
    init(coordinator: ContactsFlowCoordinator, contactService: ContactsServiceProtocol, friend: Profile? = nil, contact: Contact? = nil) {
        self.coordinator = coordinator
        self.contactsService = contactService
        self.friend = friend
        self.contact = contact
    }

    // MARK: - Methods
    func viewDidLoad() {
        view?.setupView(iPhone: contact, vkontakte: friend)
    }

    // MARK: - Private methods
    func updatePhoto() {
        guard let contact = contact, let friend = friend else { return }
        if let photoUrl = URL(string: friend.photoUrl) {
            load(url: photoUrl) { [weak self] data in
                let updatedContact = Contact(id: contact.id,
                                             firstName: contact.firstName,
                                             lastName: contact.lastName,
                                             photoData: data,
                                             mobilePhone: contact.mobilePhone
                )
                self?.contactsService.updateContact(updatedContact)
            }
        }
    }

    private func load(url: URL, completion: @escaping (Data) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
    }
}
