//
//  LoadingView.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 17/06/25.
//

import SwiftUI

struct ImageProcessorView: View {
    let image: UIImage

    @EnvironmentObject var router: Router
    @StateObject private var imageProcessorViewModel = ImageProcessorViewModel()

    var body: some View {
        VStack {
            Text("Loading...")

            #if DEBUG
            Button {
                router.navigateBack()
            } label: {
                Text("Back (debug only)")
            }

            #endif
        }
        .toolbar(.hidden)
        .onAppear {
            imageProcessorViewModel.onAppear(image, router: router)
        }
    }
}
