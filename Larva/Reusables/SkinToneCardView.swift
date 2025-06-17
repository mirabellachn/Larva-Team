import SwiftUI

struct SkinToneCardView: View {
    let skinToneColor: String
    let skinToneScale: String
    let image: String

    var body: some View {
        ZStack {
            // Background & blush
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    EllipticalGradient(
                        stops: [.init(color: Color(red: 1, green: 0.8, blue: 0.83).opacity(0.3), location: 0),
                                .init(color: Color(red: 1, green: 0.8, blue: 0.83).opacity(0.3), location: 1)],
                        center: .center
                    )
                )
                .overlay(
                    Circle()
                        .fill(Color(red: 0.9, green: 0.5, blue: 0.6).opacity(0.5))
                        .frame(width: 100, height: 100)
                        .blur(radius: 30)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(red: 1, green: 0.8, blue: 0.83).opacity(0.25), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 8) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 115)

                Text(skinToneColor)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))

                Text(skinToneScale)
                    .font(.system(size: 12))
            }
            .padding(.bottom, 10)
        }
        .frame(width: 170, height: 182)
    }
}

#Preview {
    SkinToneCardView(skinToneColor: "Light", skinToneScale: "Monk Scale no. 1", image: "baby")
}
