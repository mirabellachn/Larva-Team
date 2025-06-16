//
//  FaceDetectorDelegate.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import Vision

protocol FaceDetectorDelegate {
    func faceDetection(didDetectFaces faces: [VNFaceObservation])
}
