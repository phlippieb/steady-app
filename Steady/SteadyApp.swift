//
//  SteadyApp.swift
//  Steady
//
//  Created by Phlippie Bosman on 2024/11/21.
//

import SwiftUI
import SwiftData

@main
struct SteadyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            StreakGoalModel.self,
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
            StreaksGoals()
        }
        .modelContainer(sharedModelContainer)
    }
}
