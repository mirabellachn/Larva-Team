import SwiftUI
import AVKit

struct GuidanceModalView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var playerController = VideoPlayerController()
    
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    private let minHeight: CGFloat = 100
    private let cornerRadius: CGFloat = 20
    
    private let guidanceItems = [
        "Guidance 1",
        "Guidance 2",
        "Guidance 3",
        "Guidance 4",
        "Guidance 5",
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
                        Text("📖 Guidance")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.leading, 20)
                            .padding(.top, 30)
                        
                        Text("Here’s a cheat sheet to help you take a good picture!")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.leading, 16)
                            .padding(.bottom, 24)
                        
                        VideoPlayer(player: playerController.player)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(16/9, contentMode: .fill)
                            .cornerRadius(20)
                            .padding(EdgeInsets(top: 0, leading: 24, bottom: 10, trailing: 24))
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(spacing: 10) {
                            HStack(spacing: 30) {
                                ZStack(alignment: .bottom) {
                                    Image(systemName: "photo") //
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 128, height: 192)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .padding(.leading, 20)
                                        .overlay(Color(red: 217/255, green: 217/255, blue: 217/255)
                                        )
                                        .cornerRadius(16)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 36, height: 36)
                                        .foregroundColor(.green)
                                        .offset(y: 15)
                                    
                                }
                                
                                
                                ZStack(alignment: .bottom) {
                                    Image(systemName: "photo") //
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 128, height: 192)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .padding(.trailing, 20)
                                        .overlay(Color(red: 217/255, green: 217/255, blue: 217/255))
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
                                HStack(alignment: .center, spacing: 15) {
                                    
                                    Circle()
                                        .frame(width: 44, height: 44)
                                        .foregroundColor(Color(red: 217/255, green: 217/255, blue: 217/255))
                                        .padding(.leading, 20)
                                    
                                    
                                    Text(guidanceItems[index])
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .padding(.trailing, 20)
                                    
                                    Spacer()
                                }
                            }
                            .padding(.vertical, 8)
                            
                            
                            Button(action: {
                                print("Button tapped")
                            }) {
                                Text("Okay, I Understand")
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
                playerController.player.play()
            }
        }
    }
}

class VideoPlayerController: ObservableObject {
    let player: AVPlayer
    
    init() {
        
        guard let videoURL = Bundle.main.url(forResource: "guide_video", withExtension: "mp4") else {
            fatalError("Video file 'guide_video.mp4' not found in the bundle.")
        }
        player = AVPlayer(url: videoURL)
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.player.seek(to: .zero)
            self?.player.play()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

struct GuidanceModalView_Previews: PreviewProvider {
    static var previews: some View {
        GuidanceModalView()
    }
}
