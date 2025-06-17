import SwiftUI

struct ShadeRecommendationView: View {
    var shade: Shade

    var body: some View {
        VStack(spacing: 12) {
            // You might want to map the shade name to an actual color
            ShadeColorView(color: Color(shade.shade))
            Text(shade.shade)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))
                .frame(maxWidth: .infinity, alignment: .top)
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    ShadeRecommendationView(shade: Shade(shade: "Light Ivory"))
}
