//
//  SecuredStorage.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 08.08.2024.
//

import Foundation
import KeychainAccess

protocol SecureStoraging {

    func getString(for key: String) -> String?
    func setString(_ string: String, for key: String) throws
    func removeString(for key: String) throws
}

final class SecureStorage: SecureStoraging {

    private let keychain = Keychain()
    
    func getString(for key: String) -> String? {
        try? keychain.get(key)
    }
    
    func setString(_ string: String, for key: String) throws {
        try keychain.set(string, key: key)
    }
    
    func removeString(for key: String) throws {
        try keychain.remove(key)
    }
}
