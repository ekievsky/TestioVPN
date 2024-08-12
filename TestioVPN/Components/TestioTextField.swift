//
//  TestioTextField.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 09.08.2024.
//

import SwiftUI

struct TestioTextField: View {
    
    private let icon: Image
    private let placeholder: String
    private let isSecure: Bool
    
    @Binding private var text: String
    @FocusState private var isFocused: Bool
    
    private var isIconActive: Bool {
        isFocused || !text.isEmpty
    }
    
    var body: some View {
        HStack(spacing: 8) {
            icon
                .foregroundStyle(isIconActive ? Color.Testio.activeGray : Color.Testio.inactiveGray)
                .padding(.leading, 8)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(Font.Testio.body)
                    .focused($isFocused)
            } else {
                TextField(placeholder, text: $text)
                    .font(Font.Testio.body)
                    .focused($isFocused)
            }
            Spacer(minLength: 8)
        }
        .frame(height: 40)
        .background(Color.Testio.grayBackground)
        .clipShape(RoundedRectangle(cornerSize: .init(width: 14, height: 14)))
    }
    
    init(
        icon: Image,
        placeholder: String,
        isSecure: Bool = false,
        text: Binding<String>
    ) {
        self.icon = icon
        self.placeholder = placeholder
        self.isSecure = isSecure
        self._text = text
    }
}

#Preview {
    TestioTextField(icon: .Testio.userIcon, placeholder: "Placeholder", text: .constant(""))
}
