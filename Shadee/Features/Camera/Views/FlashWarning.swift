//
//  FlashWarning.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import SwiftUI

struct FlashWarning: View {
    var body: some View {
        HStack {
            Image(systemName: "bolt.fill")
                .foregroundStyle(.black)
            Text("Flash On")
                .font(.caption)
                .foregroundStyle(.black)
        }.padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(.warning)
            .clipShape(RoundedRectangle(cornerRadius: 36))
            .padding(.bottom, 10)
    }
}

#Preview {
    FlashWarning()
}
