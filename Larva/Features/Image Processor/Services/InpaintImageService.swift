//
//  InpainImageService.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import UIKit
import Vision

class InpaintImageService {
    static func process(from image: UIImage, faceObservation: VNFaceObservation, landmarks: VNFaceLandmarks2D?, originalImageSize: CGSize, inpaintColor: UIColor) throws -> UIImage {
        guard let orientedImage = image.orientedCorrectly() else { return image }
        guard let landmarks = landmarks, let orientedCgImage = orientedImage.cgImage else {
            return image
        }

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return image
        }

        context.translateBy(x: 0, y: image.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(orientedCgImage, in: CGRect(origin: .zero, size: image.size))
//        context.setBlendMode(.clear)
//        context.setFillColor(UIColor.clear.cgColor)
        context.setFillColor(inpaintColor.cgColor)

        let regionsToClear: [VNFaceLandmarkRegion2D?] = [
            landmarks.leftEye,
            landmarks.rightEye,
            landmarks.leftEyebrow,
            landmarks.rightEyebrow,
            landmarks.innerLips,
            landmarks.outerLips,
        ]

        for region in regionsToClear.compactMap({ $0 }) {
            // The landmark points are normalized to the original image's size.
            // We need to convert them to pixel coordinates in that original image.
            let originalPoints = region.pointsInImage(imageSize: originalImageSize)

            // Now, translate those points from the original image's coordinate system
            // to the new, cropped image's coordinate system.
            let translatedPoints = originalPoints.map { point in
                CGPoint(
                    x: point.x,
                    y: point.y
                )
            }

            // If there are no points, skip to the next region.
            guard !translatedPoints.isEmpty else { continue }

            // Create a path from the points and fill it using the .clear blend mode.
            context.beginPath()
            context.move(to: translatedPoints[0])
            for i in 1 ..< translatedPoints.count {
                context.addLine(to: translatedPoints[i])
            }
            context.closePath()
            context.fillPath()
        }

        // Retrieve the new image from our modified context.
        guard let inpaintedImage = UIGraphicsGetImageFromCurrentImageContext() else { return image }
        UIGraphicsEndImageContext()

        guard let cropped = try CropImageService.cropFace(from: inpaintedImage, for: faceObservation) else { return inpaintedImage }

        return UIImage(cgImage: cropped)
    }
}
