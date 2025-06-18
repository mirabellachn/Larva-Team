//
//  Reusables.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 16/06/25.
//

import SwiftUI

struct HeaderTextFormat: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(
                .newYork(.semibold, size: 24)
            )
            .multilineTextAlignment(.center)
            .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))
    }
}

#Preview {
    Text("Hello World")
        .modifier(HeaderTextFormat())
}
