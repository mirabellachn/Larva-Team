//
//  ImageProcessorService.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import UIKit
import Vision

class ImageProcessorService {
    static func visionProcess(image: UIImage) async throws -> ([VNFaceObservation], VNFaceObservation?)? {
        let detectFacesRequest = VNDetectFaceRectanglesRequest()
        let landmarksRequest = VNDetectFaceLandmarksRequest()
        guard let data = image.pngData() else { return nil }
        let handler = VNImageRequestHandler(data: data)
        do {
            try handler.perform([detectFacesRequest])
            guard let faceObservations = detectFacesRequest.results else { return nil }
            landmarksRequest.inputFaceObservations = faceObservations

            try handler.perform([landmarksRequest])

            guard let landmarksResult = landmarksRequest.results?.first else { return nil }

            return (faceObservations, landmarksResult)
        } catch {
            print("Error processing image: \(error)")
            return nil
        }
    }

    static func getFaceCaptureQuality(
        image: UIImage,
        from faceObservations: [VNFaceObservation]
    ) async throws -> Float {
        let qualityRequest = VNDetectFaceCaptureQualityRequest()
        guard let data = image.pngData() else { return 0 }

        let handler = VNImageRequestHandler(data: data)

        do {
            qualityRequest.inputFaceObservations = faceObservations
            try handler.perform([qualityRequest])

            return qualityRequest.results?[0].faceCaptureQuality ?? 0
        } catch {
            print("Error processing image: \(error)")
            return 0
        }
    }

    nonisolated func process(image: UIImage) async throws -> FinalResult? {
        do {
            guard let (
                faceObservations, landmarksResult
            ) = try await ImageProcessorService.visionProcess(image: image),
                let croppedCgImage = try CropImageService.cropFace(from: image, for: faceObservations[0])
            else {
                return nil
            }

            let croppedImage = UIImage(cgImage: croppedCgImage)
            guard let averageSkinColor = croppedImage.averageColor,
                  let landmarks = landmarksResult?.landmarks
            else {
                return nil
            }

            guard let inpaintedImage = try? InpaintImageService.process(
                from: image,
                faceObservation: faceObservations[0],
                originalImageSize: image.size,
                landmarks: landmarks,
                inpaintColor: averageSkinColor
            ) else {
                return nil
            }

            guard let skinToneScale = try await classifySkinTone(from: inpaintedImage),
                  let underTone = try extractUndertone(from: inpaintedImage)
            else {
                return nil
            }

            let skinTone = mapSkinTone(scale: skinToneScale)
            let skinToneDescription = getSkinToneDescription(tone: skinTone)
            let underToneDescription = getUnderToneDescription(underTone: underTone)

            return FinalResult(
                skinTone: skinTone,
                underTone: underTone,
                scale: skinToneScale,
                skinToneDescription: skinToneDescription,
                underToneDescription: underToneDescription,
                shades: getShades(for: skinTone, undertone: underTone)
            )
        } catch {
            print("Failed to perform request:", error)
            return nil
        }
    }

    private func mapSkinTone(scale: String) -> String {
        switch scale {
        case "1", "2": return "Fair"
        case "3": return "Light"
        case "4", "5": return "Medium"
        case "6": return "Tan"
        case "7": return "Deep Tan"
        case "8", "9": return "Brown"
        case "10": return "Deep"
        default: return "Unknown"
        }
    }

    private func getUnderToneDescription(underTone: String) -> String {
        switch underTone {
        case "Cool": return "Purple or Bluish"
        case "Neutral": return "Blue-green"
        case "Warm": return "Olive or Greenish"
        default: return "Anomali"
        }
    }

    private func getSkinToneDescription(tone: String) -> String {
        switch tone {
        case "Fair": return "Delicate and porcelain-like"
        case "Light": return "Soft beige skin"
        case "Medium": return "Naturally radiant"
        case "Tan": return "Golden or olive-toned"
        case "Deep Tan": return "Rich bronze-toned"
        case "Brown": return "Elegant brown rich"
        case "Deep": return "Beautifully bold and rich"
        default: return "Unknown"
        }
    }

    private func classifySkinTone(from image: UIImage) async throws -> String? {
        guard let cgImage = image.cgImage else { return nil }

        let defaultConfig: MLModelConfiguration = .init()
        let compiledModel = try MST_Skin_Tone_18_June(configuration: defaultConfig).model
        let visionModel = try VNCoreMLModel(for: compiledModel)
        let request = VNCoreMLRequest(model: visionModel)
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        try handler.perform([request])

        guard let result = request.results?.first as? VNClassificationObservation else { return nil }

        return result.identifier
    }

    private func extractUndertone(from image: UIImage) throws -> String? {
        guard image.cgImage != nil else { throw NSError(
            domain: "ImageProcessingError",
            code: -1,
            userInfo: [
                NSLocalizedDescriptionKey:
                    "Image does not have a CGImage representation."
            ]
        ) }
//        let ciImage = CIImage(cgImage: cgImage)
//        let context = CIContext(options: nil)
//        // filter to get the average color of the image
//        let filter = CIFilter(name: "CIColorAreaAverage")
//        filter?.setValue(ciImage, forKey: kCIInputImageKey)
//        filter?.setValue(CIVector(cgRect: ciImage.extent), forKey: kCIInputExtentKey)
//        guard let outputImage = filter?.outputImage else {
//            throw NSError(
//              domain: "ImageProcessingError",
//              code: -1,
//              userInfo: [NSLocalizedDescriptionKey: "Unable to apply CIFilter."]
//             )
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

    // swiftlint:disable cyclomatic_complexity
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
    // swiftlint:enable cyclomatic_complexity
}
