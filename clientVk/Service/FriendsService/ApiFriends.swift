//
//  ApiFriends.swift
//  ClientVk
//
//  Created by Filosuf on 19.04.2023.
//

import Foundation

struct ApiFriends: Decodable {
    let response: Item
}

struct Item: Decodable {
    let count: Int
    let items: [ProfileCodable]
}
