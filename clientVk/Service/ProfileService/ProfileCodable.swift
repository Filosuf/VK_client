//
//  ProfileCodable.swift
//  ClientVk
//
//  Created by Filosuf on 19.04.2023.
//

import Foundation

struct ProfileCodable: Decodable {
    let id: Int
    let photoUrl: String
    let firstName: String
    let lastName: String
    let city: City?
    let mobilePhone: String?

    private enum CodingKeys: String, CodingKey {
        case id, city
        case firstName = "first_name"
        case lastName = "last_name"
        case photoUrl = "photo_200_orig"
        case mobilePhone = "mobile_phone"
    }
}

// MARK: - City
struct City: Decodable {
    let id: Int
    let title: String
}
