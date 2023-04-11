//
//  ProfileHelper.swift
//  ClientVk
//
//  Created by Filosuf on 09.04.2023.
//

import Foundation

protocol ProfileHelperProtocol {
    func request(with token: String, user_id: String?) -> URLRequest
}

final class ProfileHelper: ProfileHelperProtocol {
    // MARK: - Methods
    func request(with token: String, user_id: String? = nil) -> URLRequest {
        let url = getURL(user_id: user_id)
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    private func getURL(user_id: String? = nil) -> URL {
        var urlComponents = URLComponents(string: "https://api.vk.com")!
        urlComponents.path = "/method/users.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "city, photo_max_orig, contacts"),
            URLQueryItem(name: "v", value: "5.131"),
        ]
        if let user_id = user_id {
            urlComponents.queryItems?.append(URLQueryItem(name: "user_ids", value: "\(user_id)"))
        }

        return urlComponents.url!
    }
}
