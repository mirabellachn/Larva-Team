//
//  ImageProcessorService.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import UIKit
import Vision

class ImageProcessorService {
    static func visionProcess(image: UIImage) async throws -> ([VNFaceObservation], Float?, VNFaceObservation?)? {
        let detectFacesRequest = VNDetectFaceRectanglesRequest()
        let qualityRequest = VNDetectFaceCaptureQualityRequest()
        let landmarksRequest = VNDetectFaceLandmarksRequest()

        guard let data = image.pngData() else { return nil }
        let handler = VNImageRequestHandler(data: data)

        do {
            try handler.perform([detectFacesRequest])
            guard let faceObservations = detectFacesRequest.results else { return nil }

            landmarksRequest.inputFaceObservations = faceObservations
            qualityRequest.inputFaceObservations = faceObservations

            try handler.perform([qualityRequest, landmarksRequest])

            guard let landmarksResult = landmarksRequest.results?.first else { return nil }

            return (faceObservations, qualityRequest.results?[0].faceCaptureQuality ?? 0, landmarksResult)
        } catch {
            print("Error processing image: \(error)")
            return nil
        }
    }

    static func process(image: UIImage) async throws -> UIImage? {
        do {
            guard let (faceObservations, _, landmarksResult) = try await visionProcess(image: image) else { return nil }
            guard let croppedCgImage = try CropImageService.cropFace(from: image, for: faceObservations[0]) else { return nil }

            let croppedImage = UIImage(cgImage: croppedCgImage)
            guard let averageSkinColor = croppedImage.averageColor else { return croppedImage }

            guard let inpaintedImage = try? InpaintImageService.process(from: image, faceObservation: faceObservations[0], landmarks: landmarksResult?.landmarks, originalImageSize: image.size, inpaintColor: averageSkinColor) else { return croppedImage }

            return inpaintedImage
        } catch {
            print("Failed to perform request:", error)

            return nil
        }
    }
}
