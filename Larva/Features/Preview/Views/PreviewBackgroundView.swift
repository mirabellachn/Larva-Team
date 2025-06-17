//
//  PreviewBackgroundView.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 17/06/25.
//

import SwiftUI

struct PreviewBackgroundView: View {
    var body: some View {
        MeshGradient(width: 3, height: 3, points: [
            [0, 0], [0.5, 0], [1, 0],
            [0, 0.5], [0.5, 0.5], [1, 0.5],
            [0, 1], [0.5, 1], [1, 1],
        ], colors: [
            .white,
            .secondaryColor1.opacity(0.5),
            .white,
            .white,
            .white,
            .white,
            .white,
            .white,
            .secondaryColor2.opacity(0.5),
        ])
        .background(.white)
        .ignoresSafeArea()
    }
}

#Preview {
    PreviewBackgroundView()
        .ignoresSafeArea()
}
