//
//  CameraService.swift
//  Extract Face Mesh Texture Test
//
//  Created by Abimanyu Damarjati on 07/06/25.
//

import AVFoundation
import UIKit
import Vision

class CameraService: NSObject, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    var delegate: FaceDetectorDelegate?

    let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let photoOutput = AVCapturePhotoOutput()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var photoCaptureCompletion: ((Result<Data, Error>) -> Void)?
    private var isConfigured = false

    func checkPermission() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            sessionQueue.suspend()
            let granted = await AVCaptureDevice.requestAccess(for: .video)

            if granted {
                sessionQueue.resume()
            }

            return granted
        default:
            return false
        }
    }

    func configureSession() {
        guard !isConfigured else { return }

        sessionQueue.async { [weak self] in
            guard let self = self else { return }

            self.captureSession.beginConfiguration()

            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
            guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
            guard self.captureSession.canAddInput(videoDeviceInput) else { return }
            self.captureSession.addInput(videoDeviceInput)

            // Photo Output
            if self.captureSession.canAddOutput(self.photoOutput) {
                self.captureSession.addOutput(self.photoOutput)
            } else {
                print("Error: Could not add photo output to the session.")
                self.captureSession.commitConfiguration()
                return
            }

            // Video data output for real-time frame processing
            if self.captureSession.canAddOutput(self.videoDataOutput) {
                self.videoDataOutput.setSampleBufferDelegate(self, queue: self.sessionQueue)
                self.captureSession.addOutput(self.videoDataOutput)

                if let connection = self.videoDataOutput.connection(with: .video) {
                    connection.videoRotationAngle = 90 // Lock orientation to portrait
                }
            } else {
                print("Error: Could not add video data output to the session.")
            }

            self.captureSession.commitConfiguration()
            self.isConfigured = true
        }
    }

    func startSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if self.isConfigured && !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
        }
    }

    func stopSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }

            if captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest { [weak self] request, error in
            if let error = error {
                print("Face detection error: \(error.localizedDescription)")
                return
            }

            guard let self = self, let results = request.results as? [VNFaceObservation] else { return }

            self.delegate?.faceDetection(didDetectFaces: results)
        }

        do {
            try VNImageRequestHandler(cmSampleBuffer: sampleBuffer, options: [:]).perform([faceDetectionRequest])
        } catch {
            print("Failed to perform face detection: \(error.localizedDescription)")
        }
    }

    func capturePhoto(completion: @escaping (Result<Data, Error>) -> Void) {
        sessionQueue.async {
            self.photoCaptureCompletion = completion
            let photoSettings = AVCapturePhotoSettings()

            // Request for Constant Color API
            photoSettings.isConstantColorEnabled = self.photoOutput.isConstantColorSupported
            photoSettings.flashMode = .on

            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            photoCaptureCompletion?(.failure(error))
        }

        guard let imageData = photo.fileDataRepresentation() else {
            let captureError = NSError(domain: "CameraServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get image data."])
            photoCaptureCompletion?(.failure(captureError))

            return
        }

        photoCaptureCompletion?(.success(imageData))
    }
}
