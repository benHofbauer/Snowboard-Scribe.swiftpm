import SwiftUI

@available(iOS 18, *)
struct ContentView: View {
    @AppStorage("firstLaunch") private var firstLaunch = true
    
    var body: some View {
        VStack {
            TabView {
                Tab("Home", systemImage: "figure.snowboarding") {
                    HomeView()
                }
                
                Tab("Data", systemImage: "book.pages.fill") {
                    SearchView()
                }
                
            }
            
        }
        .sheet(isPresented: $firstLaunch) {
            Text("Welcome to \nSnowboard Scribe!")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding()
            Image(systemName: "figure.snowboarding")
                .resizable()
                .frame(width: 100, height: 100)
            Text("On the main screen you can record new rides, and see an overview of your past ride history. \n\nIf you want to look through all your history, search for past rides, or edit/delete any wrong entries, head over to the data tab.")
                .padding()
            Button("Get Started") {
                self.firstLaunch = false
            }
        }
    }
}
