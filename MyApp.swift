import SwiftUI
import SwiftData

@available(iOS 17.0, *)
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            DataView()
        }
        .modelContainer(for: Trail.self)
    }
}
