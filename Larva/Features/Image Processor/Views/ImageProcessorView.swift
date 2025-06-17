//
//  LoadingView.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 17/06/25.
//

import SwiftUI

struct ImageProcessorView: View {
    let image: UIImage
    @StateObject private var imageProcessorViewModel = ImageProcessorViewModel()

    var body: some View {
        VStack {
            Text("Loading...")
        }
        .toolbar(.hidden)
        .navigationDestination(isPresented: $imageProcessorViewModel.isShowingResult, destination: {
            ResultView()
        })
        .onAppear {
            imageProcessorViewModel.onAppear(image)
        }
    }
}
