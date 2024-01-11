import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject private var viewModel: SkiingViewModel

    var body: some View {
        TabView {
            ResortView()
                .tabItem {
                    Label("Resort", systemImage: "house")
                }
                
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "list.dash")
                }

            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            InfoView()
                .tabItem {
                    Label("Emergency", systemImage: "exclamationmark.triangle")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SkiingViewModel())
    }
}
