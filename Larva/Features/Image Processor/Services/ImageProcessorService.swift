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

    nonisolated func process(image: UIImage) async throws -> FinalResult? {
        do {
            guard let (faceObservations, _, landmarksResult) = try await ImageProcessorService.visionProcess(image: image) else { return nil }
            guard let croppedCgImage = try CropImageService.cropFace(from: image, for: faceObservations[0]) else { return nil }

            let croppedImage = UIImage(cgImage: croppedCgImage)
            guard let averageSkinColor = croppedImage.averageColor else { return nil }
            guard let landmarksResult = landmarksResult?.landmarks else { return nil }

            guard let inpaintedImage = try? InpaintImageService.process(from: image,
                                                                        faceObservation: faceObservations[0],
                                                                        originalImageSize: image.size,
                                                                        landmarks: landmarksResult,
                                                                        inpaintColor: averageSkinColor) else { return nil }

            guard let skinToneScale = try await classifySkinTone(from: inpaintedImage) else { return nil }
            guard let underTone = try extractUndertone(from: inpaintedImage) else { return nil }
            var skinTone: String
            switch skinToneScale {
            case "1", "2":
                skinTone = "Fair"
            case "3":
                skinTone = "Light"
            case "4", "5":
                skinTone = "Medium"
            case "6":
                skinTone = "Tan"
            case "7":
                skinTone = "Deep Tan"
            case "8", "9":
                skinTone = "Brown"
            case "10":
                skinTone = "Deep"
            default:
                skinTone = "Unknown"
            }
            return FinalResult(skinTone: skinTone, underTone: underTone, scale: skinToneScale, shades: getShades(for: skinTone, undertone: underTone))
        } catch {
            print("Failed to perform request:", error)
            return nil
        }
    }
    
    private func classifySkinTone(from image: UIImage) async throws -> String? {
        guard let cgImage = image.cgImage else { return nil }

        let defaultConfig: MLModelConfiguration = .init()
        let compiledModel = try MST_Skin_Tone_1(configuration: defaultConfig).model
        let visionModel = try VNCoreMLModel(for: compiledModel)
        let request = VNCoreMLRequest(model: visionModel)
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        try handler.perform([request])

        guard let result = request.results?.first as? VNClassificationObservation else { return nil }

        return result.identifier
    }

    private func extractUndertone(from image: UIImage) throws -> String? {
        guard image.cgImage != nil else { throw NSError(domain: "ImageProcessingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Image does not have a CGImage representation."]) }
//        let ciImage = CIImage(cgImage: cgImage)
//        let context = CIContext(options: nil)
//        // filter to get the average color of the image
//        let filter = CIFilter(name: "CIColorAreaAverage")
//        filter?.setValue(ciImage, forKey: kCIInputImageKey)
//        filter?.setValue(CIVector(cgRect: ciImage.extent), forKey: kCIInputExtentKey)
//        guard let outputImage = filter?.outputImage else {
//            throw NSError(domain: "ImageProcessingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to apply CIFilter."])
//        }
//        let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent)!
//        let uiImage = UIImage(cgImage: outputCGImage)
//        guard let pixelColor = uiImage.averageColor else { return nil }

        guard let pixelColor = image.averageColor else { return nil }
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        pixelColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
//        print("Hue: \(hue)")
        var underTone: String
        if hue < 0.05 || hue > 0.9 {
            underTone = "Cool"
        } else if hue > 0.05, hue < 0.15 {
            underTone = "Neutral"
        } else {
            underTone = "Warm"
        }
        print("Undertone: \(underTone)")
        return underTone
    }
    
    private func getShades(for skinTone: String, undertone: String) -> [Shade] {
        switch (skinTone.lowercased(), undertone.lowercased()) {
        case ("fair", "cool"):
            return ["Cotton", "Beige Fair", "Perle"].map { Shade(shade: $0) }
        case ("fair", "neutral"):
            return ["Porcelain", "Light Ivory"].map { Shade(shade: $0) }
        case ("fair", "warm"):
            return ["Creme Ivory", "Warm Marble"].map { Shade(shade: $0) }

        case ("light", "cool"):
            return ["Pink Marble", "Pink Ivory"].map { Shade(shade: $0) }
        case ("light", "neutral"):
            return ["Natural Fair", "Marble", "Ivory"].map { Shade(shade: $0) }
        case ("light", "warm"):
            return ["Golden Light", "Warm Ivory"].map { Shade(shade: $0) }

        case ("medium", "cool"):
            return ["Beige Light", "Eclair", "Pink Beige"].map { Shade(shade: $0) }
        case ("medium", "neutral"):
            return ["Natural", "Natural Beige", "Sand"].map { Shade(shade: $0) }
        case ("medium", "warm"):
            return ["Golden", "Creme Sand", "Warm Beige"].map { Shade(shade: $0) }

        case ("tan", "cool"):
            return ["Beige Dark", "Cool Tan"].map { Shade(shade: $0) }
        case ("tan", "neutral"):
            return ["Natural Dark", "Tan"].map { Shade(shade: $0) }
        case ("tan", "warm"):
            return ["Honey Dark"].map { Shade(shade: $0) }

        case ("deep tan", "cool"):
            return ["Rich Cocoa"].map { Shade(shade: $0) }
        case ("deep tan", "neutral"):
            return ["Tawny"].map { Shade(shade: $0) }
        case ("deep tan", "warm"):
            return ["Creme Tan", "Creme Cocoa"].map { Shade(shade: $0) }

        case ("brown", "cool"):
            return ["Cocoa"].map { Shade(shade: $0) }
        case ("brown", "neutral"):
            return ["Ebony"].map { Shade(shade: $0) }
        case ("brown", "warm"):
            return ["Chestnut"].map { Shade(shade: $0) }

        case ("deep", "cool"), ("deep", "neutral"), ("deep", "warm"):
            return ["Deep Cocoa"].map { Shade(shade: $0) }

        default:
            return [Shade(shade: "Shade not available")]
        }
    }


}
