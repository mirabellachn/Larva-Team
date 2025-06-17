//
//  ExistStateView.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 17/06/25.
//
import SwiftUI

struct ExistStateView: View {
    var result: FinalResult
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                // Title
                HStack {
                    Text("Hi, Shade Seeker!")
                        .modifier(HeaderTextFormat())
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
            .padding(.bottom, 16)
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 16) {
                    // Skintone
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Skintone")
                            .font(.custom("NewYorkSmall-Semibold", size: 16))
                        SkinToneCardView(skinToneColor: result.skinTone,
                                         skinToneScale: "Monk Scale no. \(result.scale)",
                                         image: result.scale)
                    }
                    // Undertone
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Undertone")
                        .font(.custom("NewYorkSmall-Semibold", size: 16))
                        SkinToneCardView(skinToneColor: result.underTone,
                                         skinToneScale: "Purple or bluish veins",
                                         image: result.underTone)
                    }
                }
                .padding(.bottom, 8)
                VStack(alignment: .leading, spacing: 8) {
                    // Check this recommendation out!
                    HStack {
                        Text("Suggested Complexion Shade")
                            .font(.custom("NewYorkSmall-SemiBold", size: 16))
                        Spacer()
                    }
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
                        // Content (shade name + dummy color)
                        HStack(spacing: 0) {
                            ForEach(result.shades, id: \.shade) { shade in
                                ShadeRecommendationView(shade: shade)
                                    .padding(.top, 8)
                            }
                        }
                    }
                    .frame(width: 355, height: 159)
                }
            }
            .frame(height: 440)
            // Home page button
            NavigationLink(destination: {
                CameraView()
            }, label: {
                Text("Try Another Analysis")
                    .modifier(ButtonModifier())
            })
            .padding(.top, 124)
            .padding(.bottom, 20)
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 2, trailing: 20))
    }
}

#Preview {
    let dummyShades = [
        Shade(shade: "Light Ivory"),
        Shade(shade: "Ivory"),
        Shade(shade: "Light")
    ]
    let dummyResult = FinalResult(
        skinTone: "Light",
        underTone: "Cool",
        scale: "1",
        shades: dummyShades
    )
    ExistStateView(result: dummyResult)
}
