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
    
    private static func extractUndertone(from image: UIImage) throws -> String? {
        guard let cgImage = image.cgImage else { throw NSError(domain: "ImageProcessingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Image does not have a CGImage representation."]) }
        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext(options: nil)
        // filter to get the average color of the image
        let filter = CIFilter(name: "CIColorAreaAverage")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(CIVector(cgRect: ciImage.extent), forKey: kCIInputExtentKey)
        guard let outputImage = filter?.outputImage else {
            throw NSError(domain: "ImageProcessingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to apply CIFilter."])
        }
        let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent)!
        let uiImage = UIImage(cgImage: outputCGImage)
        guard let pixelColor = uiImage.averageColor else { return nil }
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        pixelColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
//        print("Hue: \(hue)")
        var underTone: String
        if hue < 0.05 || hue > 0.9 {
            underTone = "Cool"
        } else if hue > 0.05 && hue < 0.15 {
            underTone = "Neutral"
        } else {
            underTone = "Warm"
        }
        print("Undertone: \(underTone)")
        return underTone
    }
}
