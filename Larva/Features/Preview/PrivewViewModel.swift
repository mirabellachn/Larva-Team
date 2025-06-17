//
//  PrivewViewModel.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import UIKit

@MainActor
class PreviewViewModel: ObservableObject {
    @Published var processedImage: UIImage?

    func onAppear(_ image: UIImage) {
        Task {
            do {
                self.processedImage = try await ImageProcessorService.process(image: image)
            } catch {}
        }
    }
}
