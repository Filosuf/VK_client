//
//  ProfileService.swift
//  ClientVk
//
//  Created by Filosuf on 09.04.2023.
//

import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(_ token: String, completion: @escaping (Result<[ProfileResult], Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {

    // MARK: - Properties
    private var task: URLSessionTask?
    private var lastToken: String?
    private let profileHelper = ProfileHelper()

    // MARK: - Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<[ProfileResult], Error>) -> Void) {

        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        let request = profileHelper.request(with: token, user_id: nil)

        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ApiProfile, Error>) in
            switch result {
            case .success(let model):
                // Возвращаем данные
                let profiles = model.response
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
