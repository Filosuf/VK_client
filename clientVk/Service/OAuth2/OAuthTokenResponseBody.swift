//
//  OAuthTokenResponseBody.swift
//  ClientVk
//
//  Created by Filosuf on 22.03.2023.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
