import SwiftUI

// Global instance of SkiingViewModel
let skiingViewModel = SkiingViewModel()

@main
struct SnowiseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(skiingViewModel) // Inject SkiingViewModel into the environment
        }
    }
}
