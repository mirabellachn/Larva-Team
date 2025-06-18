//
//  FaceBoundingBoxOverlayView.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import SwiftUI

struct FaceBoundingBoxOverlayView: View {
    let boxes: [CGRect]
    let previewSize: CGSize

    var body: some View {
        ZStack {
            if !boxes.isEmpty {
                // Only the first detected face
                let box = boxes[0]
                // Vision's coordinate system is normalized and flipped.
                // Convert it to the view's coordinate system.
                let rect = CGRect(
                    x: box.origin.x * previewSize.width,
                    y: (1 - box.origin.y - box.height) * previewSize.height,
                    width: box.width * previewSize.width,
                    height: box.height * previewSize.height
                )

                Rectangle()
                    .stroke(Color.green, lineWidth: 2)
                    .frame(width: rect.width, height: rect.height)
                    .offset(x: rect.minX, y: rect.minY)
            }
        }
    }
}
