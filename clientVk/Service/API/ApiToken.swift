//
//  ApiToken.swift
//  ClientVk
//
//  Created by Filosuf on 09.04.2023.
//

import Foundation
struct ApiToken: Codable, Equatable {
    let accessToken: String
    let expiresIn: Int
    private var requestedAt: Date = .now

    init(accessToken: String, expiresIn: Int) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
    }
}

extension ApiToken {
    var isTokenValid: Bool {
        expiresAt.compare(.now) == .orderedDescending
    }

    var expiresAt: Date {
        Calendar.current.date(byAdding: .second, value: expiresIn, to: requestedAt) ?? Date()
    }
}
