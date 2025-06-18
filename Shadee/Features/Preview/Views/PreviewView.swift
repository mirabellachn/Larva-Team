//
//  PreviewView.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 17/06/25.
//

import SwiftUI
import UIKit

struct PreviewView: View {
    let image: UIImage
    let onDismiss: () -> Void

    @StateObject private var viewModel = PreviewViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: Router
    @State private var showGuidance: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(viewModel.photoCriteria.isValid() ? "Ready to analyze" : "Picture can’t be processed")
                    .font(
                        Font.custom("NewYorkSmall-Semibold", size: 24)
                            .weight(.semibold)
                    )
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(viewModel.photoCriteria.isValid() ? .success : .danger)

                Text(viewModel.photoCriteria.isValid() ? "Nice shot! Move on or retake?" : "Check how to fix it below")
                    .font(.subheadline)
                    .foregroundStyle(.black)
            }
            .padding(.top, -8)

            ImagePreviewView(previewViewModel: viewModel, image: image)
                .padding(.bottom, 16)


            VStack(spacing: 24) {
                Button(
                    action: {
                        if viewModel.photoCriteria.isValid() {
                            router.navigate(to: .imageProcessor(image: image))

                        } else {
                            dismiss()
                        }
                    }, label: {
                        Text(viewModel.photoCriteria.isValid() ? "Start Analyze" : "Retake")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                    }
                )
                .modifier(ButtonModifier())

                Button(
                    action: {
                        if viewModel.photoCriteria.isValid() {
                            dismiss()
                        } else {
                            showGuidance.toggle()
                        }
                    }, label: {
                        Text(viewModel.photoCriteria.isValid() ? "Retake" : "Read Guidance")
                            .foregroundStyle(.main)
                            .underline()
                    }
                )
                .sheet(isPresented: self.$showGuidance, content: {
                    GuidanceModalView()
                })
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(viewModel.photoCriteria.isValid() ? "Preview (Success)" : "Preview (Error)")
                .resizable()
                .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.onAppear(image)
        }
    }
}

#Preview {
    PreviewView(image: UIImage(named: "ImagePlaceholder")!) {}
}
