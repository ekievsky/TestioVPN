//
//  ServerRequest.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 09.08.2024.
//

import Foundation

enum ServerRequest: TestioRequestConvertible {
    
    case getServersList
    
    var url: String {
        return "/v1/servers"
    }
    
    var method: HTTPMethod {
        switch self {
        case .getServersList:
            return .get
        }
    }
    
    var parameters: [String : Encodable]? {
        nil
    }
    
    var headers: [String : String]? {
        nil
    }
}
