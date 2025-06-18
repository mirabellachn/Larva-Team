//
//  CameraView.swift
//  Extract Face Mesh Texture Test
//
//  Created by Abimanyu Damarjati on 07/06/25.
//

import AVFoundation
import SwiftUI

struct CameraView: View {
    @StateObject var cameraViewModel: CameraViewModel
    @EnvironmentObject var router: Router
    @Environment(\.scenePhase) var scenePhase
    @State private var showGuidance = true

    var body: some View {
        VStack {
            if !self.cameraViewModel.waitingPermission {
                if self.cameraViewModel.permissionGranted {
                    ZStack {
                        if self.scenePhase == .active {
                            GeometryReader { geometry in
                                CameraViewFinder(session: self.cameraViewModel.captureSession)
                                    .ignoresSafeArea()
                                    .background(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 36))
                                // Only shows if detected face is only one
                                if self.cameraViewModel.faceCount == 1 {
                                    FaceBoundingBoxOverlayView(
                                        boxes: self.cameraViewModel.faceBoundingBoxes,
                                        previewSize: geometry.size
                                    )
                                }
                            }
                        } else {
                            CameraEmptyStateView()
                        }
                        if !self.cameraViewModel.waitingPermission, self.cameraViewModel.permissionGranted {
                            CameraUIView(cameraViewModel: self.cameraViewModel)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)

                } else {
                    CameraPermissionDeniedView(cameraViewModel: self.cameraViewModel)
                }
            } else {
                CameraEmptyStateView()
                    .padding(.horizontal)
                    .padding(.top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            CameraBackgroundView()
        )
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading, content: {
                Button(action: {
                    self.router.navigateBack()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.main)
                })
                .padding(.leading)
            })
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    cameraViewModel.showGuidance.toggle()
                }, label: {
                    Image(systemName: "book.pages.fill")
                        .foregroundStyle(.main)
                })
                .padding(.trailing)
                .sheet(isPresented: self.$cameraViewModel.showGuidance) {
                    GuidanceModalView()
                }
            }
        })
        .onAppear {
            self.cameraViewModel.handleOnAppear()
        }
        .onChange(of: self.showGuidance) { _, newValue in
            if newValue == true {
                self.cameraViewModel.stopSession()
            } else {
                self.cameraViewModel.startSession()
            }
        }
        .onChange(of: self.scenePhase) {
            self.cameraViewModel.onScenePhaseChange(scenePhase: self.scenePhase)
        }
        .onDisappear {
            self.cameraViewModel.onDissapear()
        }
    }
}

struct CameraViewFinder: UIViewRepresentable {
    let session: AVCaptureSession
    func makeUIView(context: Context) -> UIView {
        let previewView = PreviewView()

        previewView.videoPreviewLayer.session = self.session
        previewView.videoPreviewLayer.videoGravity = .resizeAspectFill
        return previewView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No update needed for now
    }

    private class PreviewView: UIView {
        override class var layerClass: AnyClass {
            return AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            guard let layer = self.layer as? AVCaptureVideoPreviewLayer else {
                fatalError("Expected layer to be of type AVCaptureVideoPreviewLayer")
            }
            return layer
        }
    }
}

#Preview {
    NavigationStack {
        CameraView(cameraViewModel: CameraViewModel(permissionGranted: true, waitingPermission: true))
    }
}
