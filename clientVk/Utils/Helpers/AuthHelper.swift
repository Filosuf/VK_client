//
//  AuthHelper.swift
//  ClientVk
//
//  Created by Filosuf on 22.03.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> ApiToken?
}

final class AuthHelper: AuthHelperProtocol {
    // MARK: - Properties
    let configuration: AuthConfiguration

    // MARK: - LifeCycle
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }

    // MARK: - Methods
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }

    private func authURL() -> URL {
        var urlComponents = URLComponents(string: configuration.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.client_id),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "display", value: configuration.display),
            URLQueryItem(name: "response_type", value: "token"),
        ]
        return urlComponents.url!
    }

    func code(from url: URL) -> ApiToken? {
        print(url)
        if let urlComponents = URLComponents(string: url.absoluteString) {
            let path = urlComponents.path
            print(path)
            if urlComponents.path == "/blank.html" {
                var components = URLComponents()
                components.query = url.fragment

                guard let queryItems = components.queryItems,
                      let code = queryItems.first(where: { $0.name == "access_token" })?.value,
                      let expiresIn = queryItems.first(where: { $0.name == "expires_in" })?.value,
                      let userID = queryItems.first(where: { $0.name == "user_id" })?.value else { return nil }
                return ApiToken(accessToken: code, expiresIn: Int(expiresIn) ?? 0)
            }
        }
        return nil
    }
}
