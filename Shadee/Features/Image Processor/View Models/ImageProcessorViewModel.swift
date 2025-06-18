//
//  LoadingViewModel.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 17/06/25.
//

import SwiftUI

@MainActor
class ImageProcessorViewModel: ObservableObject {
    func onAppear(_ image: UIImage, router: Router) {
        Task {
            do {
                try await Task.sleep(for: .seconds(2))

                let processor = ImageProcessorService()
                guard let finalResult = try await processor.process(image: image) else { return }

                router.navigate(to: .result(result: finalResult))
            } catch {}
        }
    }
}
