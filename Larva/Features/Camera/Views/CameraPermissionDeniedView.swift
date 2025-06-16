//
//  CameraPermissionDeniedView.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import SwiftUI

struct CameraPermissionDeniedView: View {
    let cameraViewModel: CameraViewModel

    var body: some View {
        VStack {
            Text("Camera Access Denied")
                .font(.title)
                .bold()
                .padding()

            Text("Please enable camera access in your device settings to continue.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Open Settings") {
                cameraViewModel.openAppSettings()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding(.top)
        }
    }
}

#Preview {
    @Previewable @StateObject var cameraViewModel = CameraViewModel()

    CameraPermissionDeniedView(cameraViewModel: cameraViewModel)
}
