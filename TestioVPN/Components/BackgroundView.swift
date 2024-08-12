//
//  BackgroundView.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 11.08.2024.
//

import SwiftUI

struct BackgroundView: View {
    
    var body: some View {
        GeometryReader { context in
            VStack {
                Spacer()
                Image.Testio.mainImage
                    .resizable()
                    .frame(maxHeight: context.size.height / 2)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    BackgroundView()
}
