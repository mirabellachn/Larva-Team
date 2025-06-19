//
//  LoadingView.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 17/06/25.
//

import SwiftUI

struct ImageProcessorView: View {
    let image: UIImage

    @State private var isAtTop = false
    @EnvironmentObject var router: Router
    @StateObject private var imageProcessorViewModel = ImageProcessorViewModel()

    var body: some View {
        VStack(spacing: 21) {
            Image(isAtTop ? "dee2" : "dee1")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .offset(y: isAtTop ? -20 : 20)
                .animation(
                    .interpolatingSpring(stiffness: 180, damping: 12),
                    value: isAtTop
                )

            Text("Dee’s analyzing your tone...")
                .foregroundColor(.black)
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 40)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(
            Image("Loading Page")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        )
        .onAppear {
            startBounceLoop()
        }
        .toolbar(.hidden)
        .onAppear {
            imageProcessorViewModel.onAppear(image, router: router)
        }
    }

    func startBounceLoop() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            withAnimation {
                isAtTop.toggle()
            }

            timer.invalidate()

            let delay = isAtTop ? 0.4 : 0.7

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                startBounceLoop()
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var router = Router()

    ImageProcessorView(image: UIImage(named: "ImagePlaceholder")!)
        .environmentObject(router)
}
