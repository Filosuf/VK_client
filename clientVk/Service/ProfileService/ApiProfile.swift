//
//  ApiProfile.swift
//  ClientVk
//
//  Created by Filosuf on 09.04.2023.
//

import Foundation

struct ApiProfile: Decodable {
    let response: [ProfileResult]
}

struct ProfileResult: Decodable {
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
        case photoUrl = "photo_max_orig"
        case mobilePhone = "mobile_phone"
    }
}

// MARK: - City
struct City: Decodable {
    let id: Int
    let title: String
}
