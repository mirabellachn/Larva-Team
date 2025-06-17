//
//  ModalView.swift
//  Larva
//
//  Created by Mirabella on 17/06/25.
//

import SwiftUI

struct ModalView<Content: View>: View {
    @Binding var isPresented: Bool
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    private let cornerRadius: CGFloat = 20
    let content: Content

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in

            ZStack(alignment: .bottom) {
                if isPresented {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isPresented = false
                            }
                        }
                }

                VStack(spacing: 0) {
                    // Capsule di atas modal
                    Capsule()
                        .fill(Color.secondary)
                        .frame(width: 40, height: 5)
                        .padding(.top, 8)
                        .padding(.bottom, 12)

                    ScrollView(.vertical, showsIndicators: false) {
                        content
                            .padding()
                        Spacer(minLength: 20)
                    }
                    .frame(maxWidth: .infinity)
                }

                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .offset(y: isPresented ? max(offset, 0) : geometry.size.height)
                .animation(.spring(), value: isPresented)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = max(0, lastOffset + value.translation.height)
                        }
                        .onEnded { _ in
                            if offset > geometry.size.height * 0.3 {
                                withAnimation(.spring()) {
                                    isPresented = false
                                }
                            } else {
                                withAnimation(.spring()) {
                                    offset = 0
                                    lastOffset = 0
                                }
                            }
                        }
                )
            }
        }
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(isPresented: .constant(true)) {
            VStack(spacing: 16) {
                Text("Reusable Modal")
                    .font(.title2)
                Text("This modal takes up 70% of the screen height.")
                    .multilineTextAlignment(.center)
            }
        }
    }
}
