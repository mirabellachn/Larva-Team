//
//  WarningPillState.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import SwiftUI

enum WarningPillState {
    case faceNotFound
    case faceFound
    case faceMoreThanOne
}

struct WarningPillView: View {
    let state: WarningPillState

    var body: some View {
        HStack {
            switch state {
            case .faceNotFound:
                Image(systemName: "face.dashed")
                    .foregroundStyle(.black)
                Text("Face Not Found")
                    .font(.caption)
                    .foregroundStyle(.black)

            case .faceMoreThanOne:
                Image(systemName: "face.dashed.fill")
                    .foregroundStyle(.black)
                Text("Detected Multiple Faces")
                    .font(.caption)
                    .foregroundStyle(.black)

            case .faceFound:
                EmptyView()
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(.yellow)
        .clipShape(RoundedRectangle(cornerRadius: 36))
        .padding(.bottom, 10)
        .opacity(state != .faceFound ? 1 : 0)
    }
}
