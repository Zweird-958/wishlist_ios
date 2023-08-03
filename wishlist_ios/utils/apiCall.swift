//
//  api.swift
//  wishlist_ios
//
//  Created by Julien on 01/08/2023.
//

import Foundation

struct ApiResult<T: Decodable>: Decodable {
    let result: T
}

struct ApiErrorResult: Decodable {
    let error: String
}

struct ApiError: Decodable {
    let message: String
    let status: Int?

    init(message: String, status: Int? = nil) {
        self.message = message
        self.status = status
    }
}

enum ApiResponse<T: Decodable>: Decodable {
    case success(T)
    case failure(ApiError)
}

enum Method: String {
    case post = "POST"
    case get = "GET"
    case patch = "PATCH"
    case delete = "DELETE"
}

func apiCall<T: Decodable>(method: Method, path: String, body: Data?, completion: @escaping (ApiResponse<T>) -> Void) {
    if let apiUrl = ProcessInfo.processInfo.environment["API_URL"] {
        guard let url = URL(string: "\(apiUrl)/\(path)") else {
            completion(.failure(ApiError(message: "Invalid URL")))
            return
        }

        let token = UserDefaults.standard.string(forKey: Config().keys.token) ?? ""

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(token, forHTTPHeaderField: "authorization")

        if method == .post {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(ApiError(message: error.localizedDescription)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ApiError(message: "Invalid HTTP Response")))
                return
            }

            let statusCode = httpResponse.statusCode

            if let data = data {
                do {
                    if statusCode == 200 {
                        let apiResult = try JSONDecoder().decode(ApiResult<T>.self, from: data)
                        completion(.success(apiResult.result))
                    } else {
                        let apiError = try JSONDecoder().decode(ApiErrorResult.self, from: data)
                        completion(.failure(ApiError(message: apiError.error, status: statusCode)))
                    }

                } catch {
                    completion(.failure(ApiError(message: error.localizedDescription)))
                }
            } else {
                completion(.failure(ApiError(message: "No Data Receive")))
            }
        }

        task.resume()

    } else {
        completion(.failure(ApiError(message: "No API URL")))
    }
}
