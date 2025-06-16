import SwiftUI

struct ShadeRecommendationView: View {
    var body: some View {
        ZStack {
            // Background gradient
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    EllipticalGradient(
                        stops: [
                            .init(color: Color(red: 0.72, green: 0.34, blue: 0.53).opacity(0.5), location: 0),
                            .init(color: Color(red: 0.98, green: 0.95, blue: 0.95).opacity(0.5), location: 1)
                        ],
                        center: .center
                    )
                )
            // Border overlay
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.89, green: 0.8, blue: 0.85).opacity(0.3), lineWidth: 1)
            // Content
            HStack(spacing: 24) {
                VStack(spacing: 12) {
                    ShadeColorView(color: Color(red: 0.98, green: 0.93, blue: 0.88))
                    Text("Light Ivory")
                        .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))
                    .frame(maxWidth: .infinity, alignment: .top)
                }
                VStack(spacing: 12) {
                    ShadeColorView(color: Color(red: 0.98, green: 0.93, blue: 0.88))
                    Text("Ivory")
                        .font(.system(size: 16))                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))
                    .frame(maxWidth: .infinity, alignment: .top)
                }
                VStack(spacing: 12) {
                    ShadeColorView(color: Color.white)
                    Text("Light")
                        .font(.system(size: 16))                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))
                    .frame(maxWidth: .infinity, alignment: .top)
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(width: 355, height: 159)
    }
}

#Preview {
    ShadeRecommendationView()
}
