//
//  RootView.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 13/06/25.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @StateObject private var viewModel: HomeViewModel = .init(haveResults: false)

    var body: some View {
        HomeView(viewModel: viewModel)
    }
}
