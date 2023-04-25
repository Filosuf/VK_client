//
//  FriendsService.swift
//  ClientVk
//
//  Created by Filosuf on 19.04.2023.
//

import Foundation

protocol FriendsServiceProtocol {
    func fetchProfile(_ token: String, completion: @escaping (Result<[ProfileCodable], Error>) -> Void)
}

final class FriendsService: FriendsServiceProtocol {

    // MARK: - Properties
    private var task: URLSessionTask?
    private var lastToken: String?
    private let helper = FriendsHelper()

    // MARK: - Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<[ProfileCodable], Error>) -> Void) {

        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        let request = helper.request(with: token, user_id: nil)

        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ApiFriends, Error>) in
            switch result {
            case .success(let model):
                // Возвращаем данные
                let profiles = model.response.items
                DispatchQueue.main.async {
                    completion(.success(profiles))
                }
            case .failure(let error):
                self?.lastToken = nil
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
}
