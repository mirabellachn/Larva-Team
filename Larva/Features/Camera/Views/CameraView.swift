//
//  CameraView.swift
//  Extract Face Mesh Texture Test
//
//  Created by Abimanyu Damarjati on 07/06/25.
//

import AVFoundation
import SwiftUI

struct CameraView: View {
    @StateObject private var cameraViewModel = CameraViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !cameraViewModel.waitingPermission {
                    if cameraViewModel.permissionGranted {
                        if scenePhase == .active {
                            GeometryReader { geometry in
                                CameraPreview(session: cameraViewModel.captureSession)
                                    .ignoresSafeArea()
                                    .background(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 36))
                            
                                // Only shows if detected face is only one
                                if cameraViewModel.faceCount == 1 {
                                    FaceBoundingBoxOverlayView(
                                        boxes: cameraViewModel.faceBoundingBoxes,
                                        previewSize: geometry.size,
                                    )
                                }
                            }
                        } else {
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundStyle(.black)
                                .ignoresSafeArea()
                        }
                        VStack {
                            Spacer()
        
                            WarningPillView(state: cameraViewModel.faceCount == 1 ? .faceFound : cameraViewModel.faceCount > 0 ? .faceMoreThanOne : .faceNotFound)
                            
                            Button(action: {
                                #if targetEnvironment(simulator)
                                cameraViewModel.mockCapturePhoto()
                                #else
                                cameraViewModel.capturePhoto()
                                #endif
                            }) {
                                Image(systemName: "camera.circle.fill")
                                    .font(.system(size: 64))
                                    .foregroundColor(.white)
                            }
                            .disabled(cameraViewModel.faceCount != 1)
                            .padding(.bottom, 30)
                        }
                    } else {
                        CameraPermissionDeniedView(cameraViewModel: cameraViewModel)
                    }
                }
            }
            .navigationDestination(isPresented: $cameraViewModel.isShowingResult) {
                // TODO: Process image to the next screen flow
                if cameraViewModel.capturedImage != nil {
//                    SkinToneProcessorView(image: image) {
//                        cameraViewModel.clearCapturedPhoto()
//                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            cameraViewModel.onAppear()
        }
        .onChange(of: scenePhase) {
            cameraViewModel.onScenePhaseChange(scenePhase: scenePhase)
        }
        .onDisappear {
            cameraViewModel.onDissapear()
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> some UIView {
        let previewView = PreviewView()
        
        previewView.videoPreviewLayer.session = session
        previewView.videoPreviewLayer.videoGravity = .resizeAspectFill
        return previewView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    private class PreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
}

#Preview {
    CameraView()
}
