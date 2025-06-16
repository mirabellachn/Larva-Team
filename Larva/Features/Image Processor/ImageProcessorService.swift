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
            guard let inpaintedImage = try? InpaintImageService.process(from: image, faceObservation: faceObservations[0], originalImageSize: image.size, inpaintColor: averageSkinColor) else {
                return croppedImage }
            //            skinToneId = try await classifyFace(from: hollowedOutImage.cgImage!)
            guard let undertone = try? extractUndertone(from: inpaintedImage) else {
                return inpaintedImage
            }
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
