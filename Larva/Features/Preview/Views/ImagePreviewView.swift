//
//  ImagePreviewView.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 17/06/25.
//

import SwiftUI

struct ImagePreviewView: View {
    @StateObject var previewViewModel: PreviewViewModel
    let image: UIImage
    var isOnlyOneFaceDetected: Bool {
        previewViewModel.photoCriteria.isOnlyOneFaceDetected
    }

    var isFacingCamera: Bool {
        previewViewModel.photoCriteria.isFacingCamera
    }

    var isCaptureQualityGood: Bool {
        previewViewModel.photoCriteria.isCaptureQualityGood
    }

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                GeometryReader { geometry in
                    VStack(alignment: .leading, spacing: 16) {
                        Spacer()
                        PreviewCheckListItemView(
                            text: "Look at the camera",
                            checked: isFacingCamera
                        )
                        PreviewCheckListItemView(
                            text: isOnlyOneFaceDetected ?
                                "No other face detected" : "You need to be alone",
                            checked: isOnlyOneFaceDetected
                        )
                        PreviewCheckListItemView(
                            text: isCaptureQualityGood ?
                                "Crystal clear no blur" : "Stay still, don't move",
                            checked: isCaptureQualityGood
                        )
                    }
                    .padding(16)
                    .frame(width: geometry.size.width, height: geometry.size.height * 1 / 2)
                    .background(
                        LinearGradient(
                            colors: [
                                previewViewModel.photoCriteria.isValid()
                                    ? .mossGreen : .puceRed,
                                .clear
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    )
                    .offset(y: geometry.size.height * 1 / 2)
                }
            }
    }
}

#Preview {
    @Previewable @StateObject var previewViewModel = PreviewViewModel()

    VStack {
        ImagePreviewView(previewViewModel: previewViewModel, image: UIImage(named: "ImagePlaceholder")!)
    }
    .padding()
}
