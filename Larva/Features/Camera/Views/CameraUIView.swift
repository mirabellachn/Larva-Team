//
//  CameraPreviewOverlay.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import CoreHaptics
import SwiftUI

struct CameraUIView: View {
    @StateObject var cameraViewModel: CameraViewModel
    @State private var engine: CHHapticEngine?
    @State private var volumeHandler = VolumeButtonHandler()

    var body: some View {
        VStack {
            FlashWarning()

            Spacer()

            Button(action: {
                self.playOnCaptureHaptics()
                self.cameraViewModel.capturePhoto()
            }) {
                CaptureButtonView()
            }
            .onAppear {
                self.prepareHaptics()
            }
        }
        .onAppear {
            self.volumeHandler.startHandler(disableSystemVolumeHandler: false)

            self.volumeHandler.upBlock = {
                self.playOnCaptureHaptics()
                self.cameraViewModel.capturePhoto()
            }
            self.volumeHandler.downBlock = {
                self.playOnCaptureHaptics()
                self.cameraViewModel.capturePhoto()
            }
        }
        .onDisappear {
            self.volumeHandler.stopHandler()
        }
        .padding(.vertical, 24)
    }

    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try self.engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    func playHaptics(events: [CHHapticEvent]) {
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }

    func playOnCaptureHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        var events = [CHHapticEvent]()

        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        self.playHaptics(events: events)
    }
}

#Preview {
    VStack {
        CameraUIView(cameraViewModel: CameraViewModel(permissionGranted: true, waitingPermission: false))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.black)
}
