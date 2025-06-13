//
//  HomeView.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 13/06/25.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hello")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            if viewModel.haveResults {
            }
            Text("Skin Tone")
            HStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 50, height: 50)
                Text("Penjelasan")
            }
            Text("Under Tone")
            HStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 50, height: 50)
                Text("Penjelasan")
            }
            Button(action: { //NavigationLink??
                
            }) {
                Text("Analyze Your Skin")
            }
            .padding(.top)
        }
    }
}

#Preview {
    HomeView()
}
