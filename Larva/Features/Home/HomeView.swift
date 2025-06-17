//
//  HomeView.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 13/06/25.
//
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var router: Router

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Exist State
            if viewModel.haveResults {
                VStack {
                    // Texts
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hi, Shade Wise Seeker!")
                            .modifier(HeaderTextFormat())
                        Text("Your most recent analysis is in! Let’s take a look at your tone and shade 🎨")
                            .font(.custom("SF Pro", size: 16))
                            .foregroundColor(.black)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    // Result
                    // Button
                    Button(action: {
                        router.navigate(to: .camera)
                    }, label: {
                        Text("Take Another Analysis")
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            .frame(width: 320, alignment: .center)
                            .background(Color(red: 0.72, green: 0.34, blue: 0.53))
                            .cornerRadius(32)
                    })
                }
            } else { // Empty State
                VStack(alignment: .center, spacing: 16) {
                    // Texts
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hi, Shade Wise Seeker!")
                            .modifier(HeaderTextFormat())
                        Text("Let’s discover your most likely complexion shade match in just a few taps 🚀")
                            .font(.custom("SF Pro", size: 16))
                            .foregroundColor(.black)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    // Mascot Greeting
                    Circle()
                        .frame(width: 310, height: 492)
                        .foregroundStyle(Color.pink)
                    // Button
                    Button(action: {
                        router.navigate(to: .camera)
                    }) {
                        Text("Take Analysis")
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            .frame(width: 320, alignment: .center)
                            .background(Color(red: 0.72, green: 0.34, blue: 0.53))
                            .cornerRadius(32)
                    }
                }
            }
        }
        .toolbar(.hidden)
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context

    HomeView(viewModel: HomeViewModel(haveResults: true))
}
