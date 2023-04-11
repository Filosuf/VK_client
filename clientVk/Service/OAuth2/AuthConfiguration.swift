//
//  AuthConfiguration.swift
//  ClientVk
//
//  Created by Filosuf on 22.03.2023.
//

import Foundation

enum Constants {
    static let defaultBaseURL = "https://api.vk.com/method/"
    static let authorizeURLString = "https://oauth.vk.com/authorize"
    static let client_id = "51588688"
    static let redirectURI = "https://oauth.vk.com/blank.html"
    static let display = "mobile"
    static let response_type = "token"
}

struct AuthConfiguration {
    let client_id: String
    let display: String
    let redirectURI: String
    let defaultBaseURL: String
    let authURLString: String

    static var standard: AuthConfiguration {
        return AuthConfiguration(client_id: Constants.client_id,
                                 display: Constants.display,
                                 redirectURI: Constants.redirectURI,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 authURLString: Constants.authorizeURLString)
    }

    init(client_id: String, display: String, redirectURI: String, defaultBaseURL: String, authURLString: String) {
        self.client_id = client_id
        self.display = display
        self.redirectURI = redirectURI
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}

