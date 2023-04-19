//
//  URLSession+Extension.swift
//  ClientVk
//
//  Created by Filosuf on 22.03.2023.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request, completionHandler: { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
                completion(.failure(error))
                return
            }

            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 && response.statusCode >= 300 {
                completion(.failure(NetworkError.responseError))
                return
            }

            // Декодируем полученные данные
            guard let data = data else { return }
            let resultDecoding: Result<T, Error> = self.decoding(data: data)

            switch resultDecoding {
            case .success(let dataDecoded):
                // Возвращаем данные
                completion(.success(dataDecoded))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        return task
    }

    private func decoding<T: Decodable>(data: Data) -> Result<T, Error>{
//        let convertedString = String(data: data, encoding: String.Encoding.utf8)
        do {
            let decoder = JSONDecoder()
            let responseBody = try decoder.decode(T.self, from: data)
            return .success(responseBody)
        } catch {
            return.failure(NetworkError.decodeError)
        }
    }
}
