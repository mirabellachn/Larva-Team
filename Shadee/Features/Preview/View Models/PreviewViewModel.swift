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
    @Published private(set) var photoCriteria = PhotoCriteria(
        isFacingCamera: false,
        isOnlyOneFaceDetected: false,
        isCaptureQualityGood: false
    )
    @Published private(set) var isLoading: Bool = false

    init(photoCriteria: PhotoCriteria? = PhotoCriteria(
        isFacingCamera: false,
        isOnlyOneFaceDetected: false,
        isCaptureQualityGood: false
    )) {
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
        guard let (
            faceObservations,
            landmarksResult
        ) = try await ImageProcessorService.visionProcess(image: image),
                let faceCaptureQualityResult = try? await ImageProcessorService.getFaceCaptureQuality(
                    image: image,
                    from: faceObservations
                )
        else { return PhotoCriteria(isFacingCamera: false, isOnlyOneFaceDetected: false, isCaptureQualityGood: false) }

        let minYaw = NSNumber(-0.18)
        let maxYaw = NSNumber(0.18)
        let minPitch = NSNumber(-0.18)
        let maxPitch = NSNumber(0.18)

        let isOnlyOneFaceDetected = faceObservations.count == 1
        var isFacingCamera = false

        if let pitch = landmarksResult?.pitch, let yaw = landmarksResult?.yaw {
            isFacingCamera =
                pitch.compare(minPitch) == .orderedDescending &&
                pitch.compare(maxPitch) == .orderedAscending &&
                yaw.compare(minYaw) == .orderedDescending &&
                yaw.compare(maxYaw) == .orderedAscending
        }

        let isCaptureQualityGood = faceCaptureQualityResult > 0.48

        return PhotoCriteria(
            isFacingCamera: isFacingCamera,
            isOnlyOneFaceDetected: isOnlyOneFaceDetected,
            isCaptureQualityGood: isCaptureQualityGood
        )
    }
}
