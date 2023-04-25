//
//  Contact.swift
//  ClientVk
//
//  Created by Filosuf on 20.04.2023.
//

import UIKit
import Contacts

struct Contact {
    let id: String
    let firstName: String
    let lastName: String
    let photoData: Data?
    let mobilePhone: String?
    var fullName: String { "\(firstName) \(lastName)" }
}

extension Contact {
    init(contact: CNContact) {
        self.id = contact.identifier
        self.firstName = contact.givenName
        self.lastName = contact.familyName
        self.photoData = contact.imageData ?? contact.thumbnailImageData
        self.mobilePhone = (contact.phoneNumbers.first?.value)?.stringValue
    }
}
