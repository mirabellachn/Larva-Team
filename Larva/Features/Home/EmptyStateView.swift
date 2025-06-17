//
//  EmptyStateView.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 17/06/25.
//
import SwiftUI

struct EmptyStateView: View {
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
            // Home page button
            NavigationLink(destination: {
                CameraView()
            }, label: {
                Text("Take Analysis")
                    .modifier(ButtonModifier())
            })
            .padding(.top, 124)
            .padding(.bottom, 20)
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
    }
}

#Preview{
    EmptyStateView()
}
