//
//  ResultView.swift
//  Larva
//
//  Created by Louise Fernando on 17/06/25.
//

import SwiftUI

// struct ResultView: View {
//    var result: FinalResult
//    var body: some View {
//        // Body
//        NavigationStack{
//            VStack {
//                VStack(alignment: .center, spacing: 24) {
//                    Text("Based on your skin tone ")
//                        .font(.system(size: 16))
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(.black)
//                        .frame(maxWidth: .infinity, alignment: .top)
//                    // Baby Picture
//                    Rectangle()
//                        .foregroundColor(.clear)
//                        .frame(width: 169, height: 120)
//                        .background(
//                            Image("baby")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 169, height: 120)
//                                .clipped()
//                        )
//                    VStack(spacing: 5) {
//                        Text("we think you are a")
//                            .font(.system(size: 16))
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(.black)
//                            .frame(maxWidth: .infinity, alignment: .top)
//                        Text("\(result.skinTone) \(result.underTone) Person")
//                            .font(
//                                Font.custom("NewYorkSmall-SemiBold", size: 24)
//                            )
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))
//                            .frame(maxWidth: .infinity, alignment: .top)
//                    }
//                    // Text
//                    (
//                        Text("You have ")
//                        + Text("\(result.skinTone) skintone").font(.system(size: 16))
//                            .fontWeight(.bold)
//                        + Text(" with ")
//                        + Text("\(result.underTone) undertone").font(.system(size: 16))
//                            .fontWeight(.bold)
//                        + Text(". Your tone is likely to suit the complexion shade below.")
//                    )
//                    .font(.system(size: 16))
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(.black)
//                    .frame(width: 340, height: 58, alignment: .top)
//                    .padding(10)
//                    .padding(.horizontal, 6)
//                    ShadeRecommendationView(shades: result.shades)
//                }
//            }
//            .padding(.horizontal, 24)
//            .padding(.vertical, 32)
//            // Back to Home Button
//            VStack(spacing: 24) {
//                NavigationLink(destination: HomeView(), label:{
//                    Text("Save to Home Page")
//                        .modifier(ButtonModifier())
//                })
//                NavigationLink(destination: CameraView(), label:{
//                    Text("Take Another Analysis")
//                        .font(.system(size: 16))
//                        .underline(true, pattern: .solid)
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))
//                        .frame(maxWidth: .infinity, alignment: .top)
//                })
//            }
//            .padding(.top, 60)
//            .padding(.bottom, 44)
//        }
//    }
// }

struct ResultView: View {
    var result: FinalResult
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject private var router: Router

    var body: some View {
        ZStack {
            Image("Result Page")
                .resizable()
                .ignoresSafeArea(.all)
            VStack(spacing: 0) {
                mainContent
                    .padding(.horizontal, 24)
                    .padding(.vertical, 32)

                actionButtons
                    .padding(.top, 60)
                    .padding(.bottom, 44)
                    .padding(.horizontal, 36)
            }
        }
        .toolbar(.hidden)
    }

    private var mainContent: some View {
        VStack(alignment: .center, spacing: 24) {
            Text("Based on your skin tone ")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .top)

            Image("baby")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 169, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            toneInfoSection

            descriptionText

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
        }
    }

    private var toneInfoSection: some View {
        VStack(spacing: 5) {
            Text("we think you are a")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .top)

            Text("\(result.skinTone) \(result.underTone) Person")
                .font(Font.custom("NewYorkSmall-SemiBold", size: 24))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))
                .frame(maxWidth: .infinity, alignment: .top)
        }
    }

    private var descriptionText: some View {
        (
            Text("You have ")
                + Text("\(result.skinTone) skintone").fontWeight(.bold)
                + Text(" with ")
                + Text("\(result.underTone) undertone").fontWeight(.bold)
                + Text(". Your tone is likely to suit the complexion shade below.")
        )
        .font(.system(size: 16))
        .multilineTextAlignment(.center)
        .foregroundColor(.black)
        .frame(width: 340, height: 58, alignment: .top)
        .padding(10)
        .padding(.horizontal, 6)
    }

    private var actionButtons: some View {
        VStack(spacing: 24) {
            Button(action: {
                router.navigateToRoot()
            }) {
                Text("Save to Home Page")
                    .frame(maxWidth: .infinity)
            }
            .modifier(ButtonModifier())

            Button(action: {
                router.popToView(count: 3)
            }) {
                Text("Take Another Analysis")
                    .font(.system(size: 16))
                    .underline(true)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.72, green: 0.34, blue: 0.53))
                    .frame(maxWidth: .infinity, alignment: .top)
            }
        }
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

    ResultView(result: dummyResult)
}
