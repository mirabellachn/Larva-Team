//
//  PrivewViewModel.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import UIKit

@MainActor
class PreviewViewModel: ObservableObject {
    @Published private(set) var processedImage: UIImage?
    @Published private(set) var photoCriteria = PhotoCriteria(isFacingCamera: false, isOnlyOneFaceDetected: false, isCaptureQualityGood: false)
    @Published private(set) var isLoading: Bool = false

    init(photoCriteria: PhotoCriteria? = PhotoCriteria(isFacingCamera: false, isOnlyOneFaceDetected: false, isCaptureQualityGood: false)) {
        self.photoCriteria = photoCriteria ?? self.photoCriteria
    }

    func onAppear(_ image: UIImage) {
        Task {
            do {
                self.photoCriteria = try await self.validateImage(image)
            } catch {}
        }
    }

    private func validateImage(_ image: UIImage) async throws -> PhotoCriteria {
        guard let (faceObservations, faceCaptureQualityResult, landmarksResult) = try await ImageProcessorService.visionProcess(image: image) else { return PhotoCriteria(isFacingCamera: false, isOnlyOneFaceDetected: false, isCaptureQualityGood: false) }

        let minYaw = NSNumber(-0.15)
        let maxYaw = NSNumber(0.15)
        let minPitch = NSNumber(-0.15)
        let maxPitch = NSNumber(0.15)

        let isOnlyOneFaceDetected = faceObservations.count == 1
        var isFacingCamera = false

        if landmarksResult != nil {
            isFacingCamera = landmarksResult?.pitch?.compare(minPitch) == .orderedDescending && landmarksResult?.pitch?.compare(maxPitch) == .orderedAscending && landmarksResult?.yaw?.compare(minYaw) == .orderedDescending && landmarksResult?.yaw?.compare(maxYaw) == .orderedAscending
        }

        let isCaptureQualityGood = faceCaptureQualityResult ?? 0.0 > 0.48

        return PhotoCriteria(
            isFacingCamera: isFacingCamera,
            isOnlyOneFaceDetected: isOnlyOneFaceDetected,
            isCaptureQualityGood: isCaptureQualityGood
        )
    }
}
