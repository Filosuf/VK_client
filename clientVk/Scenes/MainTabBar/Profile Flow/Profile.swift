//
//  Profile.swift
//  ClientVk
//
//  Created by Filosuf on 10.04.2023.
//

import Foundation

struct Profile {
    let id: Int
    let firstName: String
    let lastName: String
    let photoUrl: String
    let city: String?
    let mobilePhone: String?
    var fullName: String { "\(firstName) \(lastName)" }

    init(profile: ProfileResult) {
        id = profile.id
        firstName = profile.firstName
        lastName = profile.lastName
        photoUrl = profile.photoUrl
        city = profile.city?.title
        mobilePhone = profile.mobilePhone
    }
}
