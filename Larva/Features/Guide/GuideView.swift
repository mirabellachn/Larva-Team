import SwiftUI

struct GuidanceModalView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    private let minHeight: CGFloat = 100
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
                Capsule()
                    .fill(Color.secondary)
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)
                
                Spacer()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("How to take the picture")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(red: 0.72, green: 0.34, blue: 0.53))
                            .padding(.leading, 15)
                            .padding(.top, 30)
                            .padding(.bottom, 8)
                        
                        Text("A simple guide to make your photo work better for the analysis!")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(.leading, 16)
                            .padding(.bottom, 24)
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(spacing: 10) {
                            HStack(spacing: 30) {
                                ZStack(alignment: .bottom) {
                                    Image("front-position")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 128, height: 192)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .padding(.leading, 20)
                                        .cornerRadius(16)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 36, height: 36)
                                        .foregroundColor(.green)
                                        .offset(y: 15)
                                }
                                
                                ZStack(alignment: .bottom) {
                                    Image("side-position")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 128, height: 192)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .padding(.trailing, 20)
//                                        .overlay(Color(red: 217/255, green: 217/255, blue: 217/255))
                                        .cornerRadius(16)
                                    
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 36, height: 36)
                                        .foregroundColor(.red)
                                        .offset(y: 15)
                                }
                            }
                            .padding(.vertical, 8)
                            
                            ForEach(guidanceItems.indices, id: \.self) { index in
                                HStack(alignment: .center, spacing: 10) {
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
                            
                            Button(action: {
                                print("Button tapped")
                            }) {
                                Text("Take a Picture")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: 0.72, green: 0.34, blue: 0.53))
                                    .clipShape(RoundedRectangle(cornerRadius: 40))
                            }
                            .padding(.horizontal, 30)
                            .padding(.top, 24)
                            
//                            Text("Watch the Tutorial")
//                                .font(.headline)
//                                .fontWeight(.semibold)
//                                .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))
//                                .underline()
//                                .padding(.top, 16)
//                                .frame(maxWidth: .infinity, alignment: .center)
//                                .onTapGesture {
//                                    print("Watch Tutorial tapped")
//                                }
                            
                            Spacer(minLength: 20)
                        }
                    }
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .offset(y: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newOffset = lastOffset + value.translation.height
                        offset = max(minHeight, newOffset)
                    }
                    .onEnded { value in
                        lastOffset = offset
                        if offset > geometry.size.height * 0.5 {
                            dismiss()
                        }
                    }
            )
            .background(
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismiss()
                    }
            )
            .ignoresSafeArea(.all, edges: .bottom)
            .onAppear {
                offset = 0
                lastOffset = 0
            }
        }
    }
}

struct GuidanceModalView_Previews: PreviewProvider {
    static var previews: some View {
        GuidanceModalView()
    }
}
