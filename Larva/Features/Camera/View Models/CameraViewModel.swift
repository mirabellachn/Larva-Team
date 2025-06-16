//
//  CameraViewModel.swift
//  Extract Face Mesh Texture Test
//
//  Created by Abimanyu Damarjati on 07/06/25.
//

import AVFoundation
import SwiftUI
@preconcurrency import Vision

@MainActor
class CameraViewModel: ObservableObject, FaceDetectorDelegate {
    private let cameraService = CameraService()
    
    @Published var captureSession: AVCaptureSession
    @Published var permissionGranted: Bool = false
    @Published var waitingPermission: Bool = true
    @Published var capturedImage: UIImage? = nil
    @Published var isShowingResult = false
    @Published var faceBoundingBoxes: [CGRect] = []
    @Published var faceCount: Int = 0
    @Published var isCapturing: Bool = false
    
    init() {
        self.captureSession = self.cameraService.captureSession
        self.cameraService.delegate = self
    }
    
    func onAppear() {
        Task {
            await self.checkPermission()
        }
    }
    
    func onScenePhaseChange(scenePhase: ScenePhase) {
        if scenePhase == .active {
            self.cameraService.startSession()
        } else {
            self.cameraService.stopSession()
        }
    }
    
    func onDissapear() {
        self.cameraService.stopSession()
    }
    
    func checkPermission() async {
        let granted = await self.cameraService.checkPermission()
        
        DispatchQueue.main.async {
            self.permissionGranted = granted
            
            if granted {
                self.cameraService.configureSession()
                self.cameraService.startSession()
            }
            
            self.waitingPermission = false
        }
    }
    
    func capturePhoto() {
        self.isCapturing = true
        self.cameraService.capturePhoto { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.capturedImage = UIImage(data: data)
                    self?.isShowingResult = true
                    self?.cameraService.stopSession()
                case .failure(let error):
                    print("Error capturing photo: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func mockCapturePhoto() {
        DispatchQueue.main.async {
            self.capturedImage = UIImage(named: "placeholder")
            self.isShowingResult = true
        }
    }
    
    func clearCapturedPhoto() {
        self.capturedImage = nil
        self.isShowingResult = false
        self.isCapturing = false
        self.cameraService.startSession()
    }
    
    nonisolated func faceDetection(didDetectFaces faces: [VNFaceObservation]) {
        // This is called on a background thread. Dispatch to the main thread for UI updates.
        DispatchQueue.main.async {
            withAnimation(.easeInOut) {
                self.faceBoundingBoxes = faces.map { $0.boundingBox }
                self.faceCount = faces.count
            }
        }
    }
    
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url)
        else {
            return
        }
        UIApplication.shared.open(url)
    }
}
