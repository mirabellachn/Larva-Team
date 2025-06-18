//
//  HomeView.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 13/06/25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: Router
    @Query() var result: [FinalResult]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Exist State
            if !result.isEmpty {
                ZStack {
                    Image("Home Page (State)")
                        .resizable()
                        .ignoresSafeArea(.all)

                    ExistStateView(result: result.last!)
                        .environmentObject(router)
                }
            } else { // Empty State
                ZStack {
                    Image("Home Page (Empty State)")
                        .resizable()
                        .ignoresSafeArea(.all)
                    EmptyStateView()
                        .environmentObject(router)
                }
            }
        }
        .toolbar(.hidden)
    }
}

#Preview {
    @Previewable @StateObject var router = Router()
    HomeView()
        .environmentObject(router)
}
