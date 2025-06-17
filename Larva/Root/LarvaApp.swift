//
//  LarvaApp.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 12/06/25.
//

import SwiftData
import SwiftUI

@main
struct LarvaApp: App {
    @StateObject private var router: Router
    @StateObject private var cameraViewModel: CameraViewModel

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FinalResult.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        let router = Router()

        #if targetEnvironment(simulator)
        let cameraViewModel = CameraViewModel(router: router, permissionGranted: true, waitingPermission: false)
        #else
        let cameraViewModel = CameraViewModel(router: router)
        #endif

        _router = StateObject(wrappedValue: router)
        _cameraViewModel = StateObject(wrappedValue: cameraViewModel)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                HomeView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .home:
                            HomeView()
                        case .camera:
                            CameraView(cameraViewModel: cameraViewModel)
                        case .preview(let image):
                            PreviewView(image: image) {
                                cameraViewModel.clearCapturedPhoto()
                            }
                        case .imageProcessor(let image):
                            ImageProcessorView(image: image)
                        case .result(let result):
                            ResultView(result: result)
                        }
                    }
            }
            .accentColor(.main)
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(router)
    }
}
