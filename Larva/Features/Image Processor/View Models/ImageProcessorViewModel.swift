//
//  LoadingViewModel.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 17/06/25.
//

import SwiftUI

@MainActor
class ImageProcessorViewModel: ObservableObject {
    @Published private(set) var processedImage: UIImage?
    @Published var isShowingResult = false

    func onAppear(_ image: UIImage) {
        Task {
            do {
                try await Task.sleep(for: .seconds(2))
                self.processedImage = try await ImageProcessorService.process(image: image)
                self.isShowingResult = self.processedImage != nil
            } catch {}
        }
    }
}
