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
                .foregroundStyle(.black)

            Text("Please enable camera access in your device settings to continue.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundStyle(.black)

            Button("Open Settings") {
                cameraViewModel.openAppSettings()
            }
            .padding()
            .background(.main)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding(.top)
        }
    }
}

#Preview {
    @Previewable @StateObject var cameraViewModel = CameraViewModel()

    CameraPermissionDeniedView(cameraViewModel: cameraViewModel)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            CameraBackgroundView()
        )
}
