//
//  Server+Mock.swift
//  TestioVPNTests
//
//  Created by Yevhen Kyivskyi on 11.08.2024.
//

import Foundation
@testable import TestioVPN

extension Server {
    static func buildMock(
        name: String = UUID().uuidString,
        distance: Int = Int.random(in: 1...1000)
    ) -> Server {
        Server(name: name, distance: distance)
    }
}
