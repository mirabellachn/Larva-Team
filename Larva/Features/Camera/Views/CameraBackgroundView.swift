//
//  CameraBackgroundView.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import SwiftUI

struct CameraBackgroundView: View {
    var body: some View {
        MeshGradient(width: 2, height: 3, points: [
            [0, 0],
            [1, 0],
            [0, 0.5],
            [1, 0.75],
            [0, 1],
            [1, 1],
        ], colors: [
            .white,
            .white,
            .white,
            .secondaryColor3,
            .secondaryColor1,
            .secondaryColor4,
        ])
        .ignoresSafeArea()
    }
}

#Preview {
    CameraBackgroundView()
        .ignoresSafeArea()
}
