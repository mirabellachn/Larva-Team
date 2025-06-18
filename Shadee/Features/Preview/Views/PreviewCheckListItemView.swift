//
//  PreviewCheckListItemView.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 17/06/25.
//

import SwiftUI

struct PreviewCheckListItemView: View {
    let text: String
    let checked: Bool

    var body: some View {
        HStack {
            Image(systemName: checked ? "checkmark.circle.fill" : "x.circle.fill")
                .foregroundStyle(checked ? .success : .danger)
            Text(text)
                .foregroundStyle(.white)
                .font(.subheadline)
            Spacer()
        }
    }
}

#Preview {
    VStack {
        PreviewCheckListItemView(text: "Look at the rear camera", checked: true)
    }
    .padding()
    .ignoresSafeArea()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.black)
}
