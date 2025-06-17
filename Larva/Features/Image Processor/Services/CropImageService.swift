//
//  CropImageService.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import UIKit
import Vision

class CropImageService {
    static func cropFace(from image: UIImage, for landmarkResult: VNFaceObservation) throws -> CGImage? {
        guard let orientedImage = image.orientedCorrectly() else { return nil }
        guard let orientedCgImage = orientedImage.cgImage else { return nil }

        let rect = VNImageRectForNormalizedRect(landmarkResult.boundingBox.flipY(), Int(image.size.width), Int(image.size.height))
        var padding: CGFloat = 100.0
        if rect.size.width < 500 {
            padding = 50.0
        } else if rect.size.width < 250 {
            padding = 20.0
        } else if rect.size.width < 100 {
            padding = 10.0
        }

        let adjustedRect = rect.insetBy(dx: padding, dy: padding)

        return orientedCgImage.cropping(to: adjustedRect)
    }
}
