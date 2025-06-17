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

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)
    }
}
