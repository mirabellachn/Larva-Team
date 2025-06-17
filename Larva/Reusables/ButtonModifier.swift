//
//  ButtonModifier.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 17/06/25.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        let cornerRadius: CGFloat = 32

        return content
            .font(.system(size: 16))
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
            .frame(width: 320, alignment: .center)
            .background(
                ZStack {
                    Color(red: 0.72, green: 0.34, blue: 0.53)

                    // Inner shadow di kanan dan atas
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.black.opacity(0.6), lineWidth: 3)
                        .blur(radius: 3)
                        .offset(x: 2, y: -2) // kanan dan atas
                        .mask(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.black.opacity(0.35)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                }
            )
            .cornerRadius(cornerRadius)
    }
}
