//
//  CaptureButtonView.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import SwiftUI

struct CaptureButtonView: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(.white)
                .frame(width: 70)
            Circle()
                .stroke(.white, lineWidth: 2)
                .frame(width: 80)
        }
    }
}

#Preview {
    VStack {
        CaptureButtonView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea()
    .background(.black)
}
