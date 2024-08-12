//
//  Image+Assets.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 08.08.2024.
//

import SwiftUI

extension Image {
    enum Testio {
        static let logo = Image("testio-logo")
        static let mainImage = Image("main-image")
        static let userIcon = Image(systemName: "person.circle")
        static let lockIcon = Image(systemName: "lock.circle")
        static let logoutIcon = Image(systemName: "rectangle.portrait.and.arrow.right")
    }
}
