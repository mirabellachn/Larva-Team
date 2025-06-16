//
//  ImageProcessorService.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import UIKit
import Vision

class ImageProcessorService {
    static func process(image: UIImage) async throws -> UIImage? {
        let detectFacesRequest = VNDetectFaceRectanglesRequest()
        let qualityRequest = VNDetectFaceCaptureQualityRequest()
        let landmarksRequest = VNDetectFaceLandmarksRequest()

        guard let data = image.pngData() else { return nil }
        let handler = VNImageRequestHandler(data: data)

        do {
            try handler.perform([detectFacesRequest])

            guard let faceObservations = detectFacesRequest.results else { return nil }
            guard let croppedCgImage = try CropImageService.cropFace(from: image, for: faceObservations[0]) else { return nil }

            landmarksRequest.inputFaceObservations = faceObservations
            qualityRequest.inputFaceObservations = faceObservations

            try handler.perform([qualityRequest, landmarksRequest])

            let croppedImage = UIImage(cgImage: croppedCgImage)
            guard let qualityResults = qualityRequest.results else { return croppedImage }
//
            _ = qualityResults[0].faceCaptureQuality
//
            guard let landmarksResults = landmarksRequest.results else { return croppedImage }

            guard let averageSkinColor = croppedImage.averageColor else { return croppedImage }

            guard let inpaintedImage = try? InpaintImageService.process(from: image, faceObservation: faceObservations[0], landmarks: landmarksResults.first?.landmarks, originalImageSize: image.size, inpaintColor: averageSkinColor) else { return croppedImage }

//            skinToneId = try await classifyFace(from: hollowedOutImage.cgImage!)

            return inpaintedImage
        } catch {
            print("Failed to perform request:", error)

            return nil
        }
    }
}
