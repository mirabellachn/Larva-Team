import SwiftUI

struct GuidanceModalView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var offset: CGFloat = 0
    private let cornerRadius: CGFloat = 20
    private let guidanceItems = [
        "Be alone, no other faces in the frame.",
        "Keep your face bare, no makeup.",
        "Look into the rear camera.",
        "Use the volume button to snap a pic.",
        "Be ready, flash turn on automatically.",
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Grabber
                Capsule()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("The Do’s Before You Snap")
                        .font(.custom("NewYorkMedium-Medium", size: 22))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(red: 0.72, green: 0.34, blue: 0.53))
                        .padding(.horizontal, 16)
                        .padding(.top, 32)
                        .padding(.bottom, 8)
                    
                    Text("A simple guide to make your photo work better for the analysis!")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                }
                
                // Images
                VStack(spacing: 8) {
                    HStack(spacing: 24) {
                        ZStack(alignment: .bottom) {
                            Image("front-position")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 128, height: 192)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(.leading, 20)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36, height: 36)
                                .foregroundColor(Color(red: 156 / 255, green: 209 / 255, blue: 33 / 255))
                                .offset(y: 15)
                        }
                        
                        ZStack(alignment: .bottom) {
                            Image("side-position")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 128, height: 192)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(.trailing, 20)
                            
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundColor(Color(red: 219/255, green: 83/255, blue: 109/255))
                                .offset(y: 15)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // Checklist
                    ForEach(guidanceItems.indices, id: \.self) { index in
                        HStack(spacing: 8) {
                            Circle()
                                .frame(width: 44, height: 44)
                                .foregroundColor(Color(red: 217/255, green: 217/255, blue: 217/255))
                            
                            Text(guidanceItems[index])
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.leading, 20)
                    }
                    
                    Spacer(minLength: 22) // Pas sesuai permintaan
                }
                .padding(.top, 12)
            }
            .background(
                Image("sub-background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
            .offset(y: offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.height > 0 {
                            offset = gesture.translation.height
                        }
                    }
                    .onEnded { _ in
                        if offset > 150 {
                            dismiss()
                        } else {
                            withAnimation(.spring()) {
                                offset = 0
                            }
                        }
                    }
            )
        }
    }
}


struct GuidanceModalView_Previews: PreviewProvider {
    static var previews: some View {
        GuidanceModalView()
    }
}

