import SwiftUI

struct ShadeColorView: View {
    var color: Color
    var width: CGFloat = 85
    var height: CGFloat = 100
    var cornerRadius: CGFloat = 16
    var body: some View {
        ZStack {
            // Base
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color)
            // Inner shadow gelap memudar dari kiri atas
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.black.opacity(0.8), lineWidth: 3)
                .blur(radius: 3)
                .offset(x: 1, y: 1)
                .mask(
                    // Gradient hitam → transparan, agar makin memudar
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black, .clear]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
            // Inner shadow terang memudar dari kanan bawah
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.white, lineWidth: 3)
                .blur(radius: 3)
                .offset(x: -1, y: -1)
                .mask(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.white, .clear]),
                                startPoint: .bottomTrailing,
                                endPoint: .topLeading
                            )
                        )
                )
        }
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color)
                .shadow(color: Color.black.opacity(0.25), radius: 6, x: 4, y: 4)
                .shadow(color: Color.white.opacity(0.3), radius: 3, x: -3, y: -3)
        )
        .frame(width: width, height: height)
    }
}

#Preview {
    ShadeColorView(color: Color(red: 0.98, green: 0.93, blue: 0.88))
}
