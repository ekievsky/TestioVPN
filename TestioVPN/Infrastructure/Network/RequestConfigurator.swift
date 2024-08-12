//
//  RequestConfigurator.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 11.08.2024.
//

import Foundation

class RequestConfigurator {
    
    func configure(request: TestioRequestConvertible, isAnonymous: Bool) -> URLRequest {
        var urlRequest = request.asURLRequest()
        if !isAnonymous {
            urlRequest.setValue(
                "Bearer \(SecureStorage().getString(for: "access-token")!)",
                forHTTPHeaderField: "Authorization"
            )
        }
        
        if request.method == .post {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}
