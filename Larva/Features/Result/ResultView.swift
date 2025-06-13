import Foundation
import SwiftUI

struct ResultView: View {
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                // Title
                HStack {
                    Text("Hi Mate!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                // SubTitle
                HStack {
                    Text("This is your skin color analysis result ✨")
                        .font(.title3)
                    Spacer()
                }
            }
            HStack(spacing: 45) {
                // Skintone
                VStack(alignment: .center, spacing: 8) {
                    Text("Skintone")
                        .font(.system(size: 16))
                    Circle()
                        .fill(Color.black.opacity(0.2))
                        .stroke(Color.black, lineWidth: 0.5)    .frame(width: 100, height: 100)
                    Text("Light")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    Text("Kulit kamu terang")
                        .font(.system(size: 16))
                }
                // Undertone
                VStack(alignment: .center, spacing: 8) {
                    Text("Undertone")
                        .font(.system(size: 16))
                    Circle()
                        .fill(Color.black.opacity(0.2))
                        .stroke(Color.black, lineWidth: 0.5)    .frame(width: 100, height: 100)
                    Text("Cool")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    Text("Kulit kamu cool")
                        .font(.system(size: 16))
                }
            }
            .padding(.bottom, 16)
            VStack(spacing: 8) {
                // Complextion Shade
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.white)
                        .stroke(Color.black, lineWidth: 1)    .frame(width: 24, height: 24)
                    Text("Complexion Shade")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    Spacer()
                }
                // Check this recommendation out!
                HStack {
                    Text("Check this recommendation out! ")
                        .font(.title3)
                    Spacer()
                }
                HStack(spacing: 24) {
                    // Shade recommendation
                    VStack {
                        Circle()
                            .fill(Color.black.opacity(0.2))
                            .stroke(Color.black, lineWidth: 0.5)    .frame(width: 85, height: 85)
                        Text("Light Ivory")
                            .font(.system(size: 16))
                    }
                    VStack {
                        Circle()
                            .fill(Color.black.opacity(0.2))
                            .stroke(Color.black, lineWidth: 0.5)    .frame(width: 85, height: 85)
                        Text("Ivory")
                            .font(.system(size: 16))
                    }
                    VStack {
                        Circle()
                            .fill(Color.black.opacity(0.2))
                            .stroke(Color.black, lineWidth: 0.5)    .frame(width: 85, height: 85)
                        Text("Light")
                            .font(.system(size: 16))
                    }
                }
                .padding(.top, 8)
            }
            Spacer()
            // Home page button
            HStack(alignment: .center, spacing: 10) {
                Text("Back to Home Page")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
            .frame(width: 320, alignment: .center)
            .background(Color(red: 0.72, green: 0.34, blue: 0.53))
            .cornerRadius(32)
            // Retake Button
            Text("Take Another Analysis")
                .font(.system(size: 16))
                .underline(true, pattern: .solid)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))
                .frame(maxWidth: .infinity, alignment: .top)
                .padding(.bottom, 48)
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .padding(.top, 32)
    }
}

#Preview {
    ResultView()
}
