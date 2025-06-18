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
                    Text("Ready to tone it right? Let your skin lead the shade parade!")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: 320, alignment: .leading)
                        .padding(.bottom, 8)
                    Spacer()
                }
            }
            .padding(.bottom, 32)
                Image("EmptyStateMascot")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 480)
                    .frame(maxWidth: .infinity)
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
