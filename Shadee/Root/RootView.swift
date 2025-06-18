//
//  RootView.swift
//  Larva
//
//  Created by Mirabella on 17/06/25.
//

import SwiftUI

struct RootView: View {
    @State private var showGuidance = false

    var body: some View {
        VStack {
            Button(
                action: {
                    showGuidance.toggle()
                }, label: {
                    Text(showGuidance ? "Hide Guidance" : "Show Guidance")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            )
        }
        .sheet(isPresented: $showGuidance) {
            GuidanceModalView()
                .presentationDetents([.fraction(0.9)])
                .presentationDragIndicator(.visible)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
