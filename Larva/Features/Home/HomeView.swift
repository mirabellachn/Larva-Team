//
//  HomeView.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 13/06/25.
//
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    var result: FinalResult
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationStack {
                // Exist State
                if viewModel.haveResults {
                    ZStack {
                        Image("Home Page (State)")
                            .resizable()
                            .ignoresSafeArea(.all)
                        ExistStateView(result: result)
                    }
                } else { // Empty State
                    ZStack {
                        Image("Home Page (State)")
                            .resizable()
                            .ignoresSafeArea(.all)
                        EmptyStateView()
                    }
                }
            }
        }
    }
}

#Preview {
    let dummyShades = [
        Shade(shade: "Light Ivory"),
        Shade(shade: "Ivory"),
        Shade(shade: "Light")
    ]
    let dummyResult = FinalResult(
        skinTone: "Light",
        underTone: "Cool",
        scale: "1",
        shades: dummyShades
    )
    HomeView(viewModel: HomeViewModel(haveResults: true), result: dummyResult)
}
