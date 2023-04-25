//
//  ContactsService.swift
//  ClientVk
//
//  Created by Filosuf on 21.04.2023.
//

import UIKit
import Contacts

protocol ContactsServiceProtocol {
    func getPhoneContacts() -> [Contact]
    func updateContact(_ contact: Contact)
}

final class ContactsService: ContactsServiceProtocol {
    // MARK: - Properties
    private var contacts: [CNContact] = []
    // MARK: - Initialiser
    // MARK: - LifeCycle

    // MARK: - Methods
    func getPhoneContacts() -> [Contact] {
        contacts = getAllContacts()
        return contacts.map { Contact(contact: $0) }
    }

    func updateContact(_ contact: Contact) {
        if let foundContact = fetchContact(identifier: contact.id),
           let editContact = foundContact.mutableCopy() as? CNMutableContact {
            editContact.imageData = contact.photoData
            saveContact(editContact)
        }

    }

    private func saveContact(_ contact: CNMutableContact) {
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.update(contact)
        try! store.execute(saveRequest)
    }

    private func fetchContact(identifier: String) -> CNContact? {
        return contacts.first(where: { $0.identifier == identifier} )
    }

    private func fetchContact(phoneNumber: String) -> CNContact? {
        var result: [CNContact] = []

        for contact in self.contacts {
            if (!contact.phoneNumbers.isEmpty) {
                for contactPhoneNumber in contact.phoneNumbers {
                    let phoneNumberString = contactPhoneNumber.value.stringValue
                    if phoneNumber.shortPhoneNumber() == phoneNumberString.shortPhoneNumber() {
                        result.append(contact)
                    }
                }
            }
        }
        return result.first
    }

    // MARK: - Private methods
    private func getAllContacts() -> [CNContact] {
        let contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey,
                CNContactImageDataKey] as [Any]

            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {

            }

            var results: [CNContact] = []

            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {

                }
            }

            return results
        }()

        return contacts
    }
}
