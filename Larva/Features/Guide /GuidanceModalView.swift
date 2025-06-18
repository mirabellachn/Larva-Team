import SwiftUI

struct GuidanceModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var sheetHeight: CGFloat = 300
    @State private var offset: CGFloat = 0
    private let cornerRadius: CGFloat = 20
    private let guidanceItems: [(icon: String, text: String)] = [
        ("person.fill", "Be alone, no other faces in the frame"),
        ("face.smiling", "Bare face and no accessories"),
        ("viewfinder", "Look into the rear camera"),
        ("camera.fill", "Use the volume button to snap a pic"),
        ("bolt.fill", "Be ready, flash turn on automatically!")
    ]
    // Body
    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(.secondaryColor3)
                .frame(width: 40, height: 5)
                .padding(.vertical, 8)

            VStack(alignment: .leading, spacing: 8) {
                Text("The Do’s Before You Snap")
                    .font(.newYork(.semibold, size: 22))
                    .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))

                Text("A simple guide to make your photo work better for the analysis!")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)

            HStack(spacing: 24) {
                ZStack(alignment: .bottom) {
                    Image("front-position")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 128, height: 192)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    Image("CheckMarkIcon")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundColor(Color(red: 0.61, green: 0.82, blue: 0.13))
                        .offset(y: 15)
                }

                ZStack(alignment: .bottom) {
                    Image("side-position")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 128, height: 192)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    Image("XMarkIcon")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundColor(Color(red: 0.86, green: 0.33, blue: 0.43))
                        .offset(y: 15)
                }
            }

            // Checklist
            VStack(alignment: .leading, spacing: 8) {
                ForEach(guidanceItems, id: \.text) { item in
                    HStack(spacing: 8) {
                        Image(iconName(for: item.icon))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .padding(5)
                            .clipShape(Circle())

                        Text(item.text)
                            .foregroundColor(.black)
                            .font(.system(size: 16))

                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .background(
            Image("sub-background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .overlay {
            GeometryReader { geometry in
                Color.clear.preference(
                    key: InnerHeightPreferenceKey.self,
                    value: geometry.size.height
                )
            }
        }
        .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
            self.sheetHeight = newHeight
        }
        .presentationDetents([.height(sheetHeight)])
    }

    private func iconName(for systemIcon: String) -> String {
        switch systemIcon {
        case "person.fill": return "person-fill"
        case "face.smiling": return "no-acc"
        case "viewfinder": return "rear-camera"
        case "camera.fill": return "volume-button"
        case "bolt.fill": return "flash"
        default: return "placeholder-icon"
        }
    }
}

struct GuidanceModalView_Previews: PreviewProvider {
    static var previews: some View {
        GuidanceModalView()
    }
}
