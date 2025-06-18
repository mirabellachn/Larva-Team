//
//  ExistStateView.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 17/06/25.
//
import SwiftUI

struct ExistStateView: View {
    var result: FinalResult
    @EnvironmentObject var router: Router
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Hi, Shade Seeker!")
                    .modifier(HeaderTextFormat())
                Text("Your most recent analysis is in! Let’s take a look at your tone and shade 🎨")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 8)
            }
            .padding(.bottom, 8)
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 16) {
                    // Skintone
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Skintone")
                            .font(.newYork(.semibold, size: 16))
                        SkinToneCardView(skinToneColor: result.skinTone,
                                         skinToneScale: result.skinToneDescription,
                                         image: result.scale)
                    }
                    // Undertone
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Undertone")
                            .font(.newYork(.semibold, size: 16))
                        SkinToneCardView(skinToneColor: result.underTone,
                                         skinToneScale: "\(result.underToneDescription) veins",
                                         image: result.underTone)
                    }
                }
                .padding(.bottom, 8)
                VStack(alignment: .leading, spacing: 8) {
                    // Check this recommendation out!
                    HStack {
                        Text("Suggested Complexion Shade")
                            .font(.newYork(.semibold, size: 16))
                        Spacer()
                    }
                    ZStack {
                        // Background gradient
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                EllipticalGradient(
                                    stops: [
                                        .init(color:
                                                Color(red: 0.72, green: 0.34, blue: 0.53).opacity(0.5), location: 0),
                                        .init(color:
                                                Color(red: 0.98, green: 0.95, blue: 0.95).opacity(0.5), location: 1)
                                    ],
                                    center: .center
                                )
                            )
                        // Border overlay
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.89, green: 0.8, blue: 0.85).opacity(0.3), lineWidth: 1)
                        // Content (shade name + dummy color)
                        HStack(spacing: -20) {
                            ForEach(result.shades, id: \.shade) { shade in
                                ShadeRecommendationView(shade: shade)
                            }
                        }
                    }
                }
            }
            // Home page button
            HStack {
                Spacer()
                Button(action: {
                    router.navigate(to: .camera)
                }, label: {
                    Text("Try Another Analysis")
                        .modifier(ButtonModifier())
                })
                Spacer()
            }
            .padding(.top, 124)
            .padding(.bottom, 20)
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 2, trailing: 20))
        .preferredColorScheme(.light)
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
        skinToneDescription: "Dummy dummy",
        underToneDescription: "Dummy dummy",
        shades: dummyShades
    )
    ExistStateView(result: dummyResult)
}
