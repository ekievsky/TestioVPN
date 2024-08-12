//
//  NetworkManager.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 08.08.2024.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

class NetworkManager {
    private let requestConfigurator: RequestConfigurator
    
    init(requestConfigurator: RequestConfigurator) {
        self.requestConfigurator = requestConfigurator
    }
    
    func request<T: Decodable>(_ request: TestioRequestConvertible, isAnonymous: Bool = true) async throws -> T {
        do {
            let urlRequest = requestConfigurator.configure(request: request, isAnonymous: isAnonymous)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            } catch let decodingError {
                throw NetworkError.decodingFailed(decodingError)
            }
        } catch let error {
            throw NetworkError.requestFailed(error)
        }
    }
}
