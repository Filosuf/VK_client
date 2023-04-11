//
//  OAuth2Service.swift
//  ClientVk
//
//  Created by Filosuf on 22.03.2023.
//

import Foundation

protocol OAuth2ServiceProtocol {
    func fetchAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void)
}

enum NetworkError: Error {
    case responseError
    case decodeError
}

final class OAuth2Service: OAuth2ServiceProtocol {
    // MARK: - Properties
    private var task: URLSessionTask?
    private var lastCode: String?

    // MARK: - Properties
    func fetchAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        var urlComponents = URLComponents(string: Constants.authorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.client_id),
            URLQueryItem(name: "display", value: Constants.display),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "token")
        ]
        let url = urlComponents.url!

        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code

        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "POST"

        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                // Возвращаем данные
                DispatchQueue.main.async {
                    completion(.success(model.accessToken))
                }
            case .failure(let error):
                self.lastCode = nil
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
}
