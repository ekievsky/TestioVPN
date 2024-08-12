//
//  TestioRequestConvertible.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 08.08.2024.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
}

protocol TestioRequestConvertible {
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Encodable]? { get }
    var headers: [String: String]? { get }
    
    func asURLRequest(serverConfig: ServerConfig) throws -> URLRequest
}

extension TestioRequestConvertible {
    func asURLRequest(serverConfig: ServerConfig = DependencyContainer.shared.serverConfig) -> URLRequest {
        var request = URLRequest(url: URL(string: "\(serverConfig.domain)\(url)")!)
        request.httpMethod = method.rawValue
        
        if let parameters {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonData
        }

        return request
    }
}
