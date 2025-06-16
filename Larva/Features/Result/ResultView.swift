import Foundation
import SwiftUI

struct ResultView: View {
    let shades = ["Light Ivory", "Ivory", "Light"]
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                // Title
                HStack {
                    Text("Hi, Shade Seeker!")                                 .font(.custom("NewYorkSmall-Semibold", size: 24))
                    
                        .overlay(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.72, green: 0.34, blue: 0.53), location: 0.00), Gradient.Stop(color: Color(red: 1, green: 0.68, blue: 0.78), location: 1.0)
                                ],
                                startPoint: UnitPoint(x: 0, y: -0.78),
                                endPoint: UnitPoint(x: 0.73, y: 1.33)
                            )
                            .mask(
                                Text("Hi, Shade Seeker!")            .font(.custom("NewYorkSmall-Semibold", size: 24))
                                
                            )
                        )
                    Spacer()
                }
                // SubTitle
                HStack {
                    Text("We’ve found a shade that most likely aligns with your personal tone ✨")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: 320, alignment: .leading) // batas lebar agar distribusi kata lebih baik
               
                    Spacer()
                }
            }
            HStack(spacing: 45) {
                // Skintone
                VStack(alignment: .leading, spacing: 8) {
                    Text("Skintone")
                        .font(.custom("NewYorkSmall-Semibold", size: 16))
                    Circle()
                        .fill(Color.black.opacity(0.2))
                        .stroke(Color.black, lineWidth: 0.5)    .frame(width: 100, height: 100)
                    Text("Light")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))
                    Text("Monk Scale no. 1")
                        .font(.system(size: 12))
                }
                // Undertone
                VStack(alignment: .leading, spacing: 8) {
                    Text("Undertone")
                        .font(.custom("NewYorkSmall-Semibold", size: 16))
                    Circle()
                        .fill(Color.black.opacity(0.2))
                        .stroke(Color.black, lineWidth: 0.5)    .frame(width: 100, height: 100)
                    Text("Cool")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))
                    
                    Text("Purple or bluish veins")
                        .font(.system(size: 12))
                }
            }
            .padding(.bottom, 16)
            VStack(spacing: 8) {
                // Check this recommendation out!
                HStack {
                    Text("Complexion Shade Recommendations")
                        .font(.custom("NewYorkSmall-SemiBold", size: 16))
                    Spacer()
                }
                HStack(spacing: 24) {
                    // Shade recommendation
                    HStack(spacing: 24) {
                        ForEach(shades, id: \.self) { shade in
                            VStack {
                                Circle()
                                    .fill(Color.black.opacity(0.2))
                                    .overlay(Circle().stroke(Color.black, lineWidth: 0.5))
                                    .frame(width: 85, height: 85)
                                Text(shade)
                                    .font(.system(size: 16))
                            }
                        }
                    }
                    .padding(.top, 8)
                }
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
        .padding(EdgeInsets(top: 32, leading: 16, bottom: 0, trailing: 16)
    }
}

#Preview {
    ResultView()
}
