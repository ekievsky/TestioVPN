//
//  AuthorizationRequest.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 08.08.2024.
//

import Foundation

enum AuthorizationRequest: TestioRequestConvertible {
    
    case getToken(userName: String, password: String)
    
    var url: String {
        return "/v1/tokens"
    }
    
    var method: HTTPMethod {
        switch self {
        case .getToken:
            return .post
        }
    }
    
    var parameters: [String : Encodable]? {
        switch self {
        case .getToken(let userName, let password):
            return ["username": userName, "password": password]
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
}
