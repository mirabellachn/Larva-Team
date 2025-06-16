import Foundation
import SwiftUI

struct ResultView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 24) {
                VStack(spacing: 8) {
                    // Title
                    HStack {
                        Text("Hi, Shade Seeker!")
                            .font(.custom("NewYorkSmall-Semibold", size: 24))
                            .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))
                        Spacer()
                    }
                    // SubTitle
                    HStack {
                        Text("Your most recent analysis is in! Let’s take a look at your tone and shade 🎨")
                            .font(.system(size: 16))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: 320, alignment: .leading)
                        Spacer()
                    }
                }
                HStack(spacing: 16) {
                    // Skintone
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Skintone")
                            .font(.custom("NewYorkSmall-Semibold", size: 16))
                        SkinToneCardView(skinToneColor: "Light", skinToneScale: "Monk Scale no. 1", image: "baby")
                    }
                    // Undertone
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Undertone")
                        .font(.custom("NewYorkSmall-Semibold", size: 16))
                        SkinToneCardView(skinToneColor: "Cool", skinToneScale: "Purple or bluish veins", image: "coolTone")
                    }
                }
                .padding(.bottom, 8)
                VStack(alignment: .leading, spacing: 8) {
                    // Check this recommendation out!
                    HStack {
                        Text("Complexion Shade Recommendations")
                            .font(.custom("NewYorkSmall-SemiBold", size: 16))
                        Spacer()
                    }
                    ShadeRecommendationView()
                        .padding(.top, 8)
                }
            }
            // Home page button
            VStack {
                HStack(alignment: .center, spacing: 10) {
                    Text("Take Another Analysis")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .frame(width: 320, alignment: .center)
                .background(Color(red: 0.72, green: 0.34, blue: 0.53))
                .cornerRadius(32)
            }
            .padding(.top, 82)
            .padding(.bottom, 68)
        }
        .padding(EdgeInsets(top: 32, leading: 20, bottom: 0, trailing: 20))
    }
}
#Preview {
    ResultView()
}
