//
//  EmptyStateView.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 17/06/25.
//
import SwiftUI

struct EmptyStateView: View {
    @EnvironmentObject var router: Router

    var body: some View {
        VStack {
            VStack(spacing: 8) {
                // Title
                HStack {
                    Text("Hi, Shade Seeker!")
                        .modifier(HeaderTextFormat())
                    Spacer()
                }
                // SubTitle
                HStack {
                    Text("Let’s discover your most likely complexion shade match in just a few taps 🚀")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: 320, alignment: .leading)
                    Spacer()
                }
            }
            .padding(.bottom, 16)

            VStack(alignment: .leading, spacing: 24) {
                Circle()
                    .frame(height: 440)
            }

            Spacer()

            // Home page button
            Button(action: {
                router.navigate(to: .camera)
            }, label: {
                Text("Take Analysis")
                    .frame(maxWidth: .infinity)
            })
            .modifier(ButtonModifier())
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
    }
}

#Preview {
    @Previewable @StateObject var router = Router()

    EmptyStateView()
        .environmentObject(router)
}
