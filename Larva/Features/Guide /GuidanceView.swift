//
//  GuidanceView.swift
//  Larva
//
//  Created by Mirabella on 17/06/25.
//

import SwiftUI

struct GuidancePage: View {
    
    private let guidanceItems = [
        "Be alone, no other faces in the frame.",
        "Keep your face bare, no makeup.",
        "Look into the rear camera.",
        "Use the volume button to snap a pic.",
        "Be ready, flash turn on automatically.",
    ]
    
    private let cornerRadius: CGFloat = 20

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
//                Capsule()
//                    .fill(Color.secondary)
//                    .frame(width: 40, height: 5)
//                    .padding(.top, 8)
//                    .frame(maxWidth: .infinity, alignment: .center)

                Text("How to take the picture")
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

                HStack(spacing: 24) {
                    ZStack(alignment: .bottom) {
                        Image("front-position")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 128, height: 192)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.leading, 50)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .foregroundColor(Color(red: 156/255, green: 209/255, blue: 33/255))
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

                ForEach(guidanceItems.indices, id: \.self) { index in
                    HStack(alignment: .center, spacing: 8) {
                        Circle()
                            .frame(width: 44, height: 44)
                            .foregroundColor(Color(red: 217/255, green: 217/255, blue: 217/255))
                        
                        Text(guidanceItems[index])
                            .font(.system(size: 16))
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
                .padding(.top, 19)
                
                Spacer(minLength: 40)
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .ignoresSafeArea(.keyboard)
    }
}

struct GuidancePage_Previews: PreviewProvider {
    static var previews: some View {
        GuidancePage()
    }
}

