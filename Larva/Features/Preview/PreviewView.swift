//
//  PreviewView.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 13/06/25.
//

import SwiftUI
import UIKit

struct PreviewView: View {
    let image: UIImage
    let onDismiss: () -> Void
    @StateObject private var processor = PreviewViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            if processor.processedImage != nil {
                Image(uiImage: processor.processedImage!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            processor.onAppear(image)
        }
    }
}
