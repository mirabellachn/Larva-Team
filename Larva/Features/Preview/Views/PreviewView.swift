//
//  PreviewView.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 17/06/25.
//

import SwiftUI
import UIKit

struct PreviewView: View {
    let image: UIImage?
    let onDismiss: () -> Void

    @StateObject private var viewModel = PreviewViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: Router

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 8) {
                Text(viewModel.photoCriteria.isValid() ? "Ready to analyze" : "Picture can’t be processed")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(viewModel.photoCriteria.isValid() ? .success : .danger)

                Text(viewModel.photoCriteria.isValid() ? "Nice shot! Move on or retake?" : "Check how to fix it below")
                    .font(.subheadline)
                    .foregroundStyle(.black)
            }

            Image(uiImage: image!)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay {
                    GeometryReader { geometry in
                        VStack(alignment: .leading, spacing: 16) {
                            Spacer()
                            PreviewCheckListItemView(text: "Look at the camera", checked: viewModel.photoCriteria.isFacingCamera)
                            PreviewCheckListItemView(text: viewModel.photoCriteria.isOnlyOneFaceDetected ? "No other face detected" : "You need to be alone", checked: viewModel.photoCriteria.isOnlyOneFaceDetected)
                            PreviewCheckListItemView(text: viewModel.photoCriteria.isCaptureQualityGood ? "Crystal clear no blur" : "Stay still, don't move", checked: viewModel.photoCriteria.isCaptureQualityGood)
                        }
                        .padding(24)
                        .frame(width: geometry.size.width, height: geometry.size.height * 1 / 2)
                        .background(
                            LinearGradient(colors: [viewModel.photoCriteria.isValid() ? .mossGreen : .puceRed, .clear], startPoint: .bottom, endPoint: .top)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        )
                        .offset(y: geometry.size.height * 1 / 2)
                    }
                }
            VStack(spacing: 24) {
                Button(action: {
                    if viewModel.photoCriteria.isValid() {
                        if let image = image {
                            router.navigate(to: .imageProcessor(image: image))
                        }
                    } else {
                        dismiss()
                    }
                }) {
                    Text(viewModel.photoCriteria.isValid() ? "Start Analyze" : "Retake")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 32)
                        .foregroundStyle(.main)
                )

                Button(action: {
                    if viewModel.photoCriteria.isValid() {
                        dismiss()
                    }
                }) {
                    Text(viewModel.photoCriteria.isValid() ? "Retake" : "Read Guidance")
                        .foregroundStyle(.main)
                        .underline()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            PreviewBackgroundView()
        )
        .navigationBarBackButtonHidden(true)
        .onAppear {
            guard let image else {
                dismiss()
                return
            }
            viewModel.onAppear(image)
        }
    }
}

#Preview {
    PreviewView(image: UIImage(named: "ImagePlaceholder")) {}
}
