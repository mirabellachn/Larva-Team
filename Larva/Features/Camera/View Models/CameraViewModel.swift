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
    private let router: Router?
    @AppStorage("hasSeenCameraGuidance") private var hasSeenCameraGuidance: Bool = false
    @Published private(set) var captureSession: AVCaptureSession
    @Published private(set) var permissionGranted: Bool = false
    @Published private(set) var waitingPermission: Bool = true
    @Published private(set) var capturedImage: UIImage?
    @Published private(set) var faceBoundingBoxes: [CGRect] = []
    @Published private(set) var faceCount: Int = 0
    @Published private(set) var isCapturing: Bool = false
    @Published var isShowingResult = false
    @Published var showGuidance: Bool = false

    init(router: Router? = nil, permissionGranted: Bool? = false, waitingPermission: Bool? = true) {
        self.waitingPermission = waitingPermission ?? true
        self.permissionGranted = permissionGranted ?? false
        self.captureSession = self.cameraService.captureSession
        self.router = router
        self.cameraService.delegate = self
    }

    func isSessionRunning() -> Bool {
        return self.cameraService.captureSession.isRunning
    }

    func onAppear() {
        if !hasSeenCameraGuidance {
            showGuidance = true
            hasSeenCameraGuidance = true
        } else {
            Task {
                await self.checkPermission()
            }
        }
    }

    func stopSession() {
        self.cameraService.stopSession()
    }

    func startSession() {
        self.cameraService.startSession()
    }

    func onScenePhaseChange(scenePhase: ScenePhase) {
        if scenePhase == .active {
            self.startSession()
        } else {
            self.stopSession()
        }
    }

    func onDissapear() {
        self.stopSession()
    }

    func checkPermission() async {
        let granted = await self.cameraService.checkPermission()
        DispatchQueue.main.async {
            self.permissionGranted = granted
            if granted {
                self.cameraService.configureSession()
                self.startSession()
            }
            self.waitingPermission = false
        }
    }

    func capturePhoto() {
#if targetEnvironment(simulator)
        self.mockCapturePhoto()
#else
        self.isCapturing = true
        self.cameraService.capturePhoto { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }
                    self?.capturedImage = UIImage(data: data)
                    self?.isShowingResult = true
                    self?.stopSession()
                    self?.router?.navigate(to: .preview(image: image))
                case .failure(let error):
                    print("Error capturing photo: \(error.localizedDescription)")
                }
            }
        }
#endif
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
        self.startSession()
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
