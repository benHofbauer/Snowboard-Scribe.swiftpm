import SwiftUI
import SwiftData

@available(iOS 18.0, *)
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Trail.self)
    }
}
