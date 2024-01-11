import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject private var viewModel: SkiingViewModel

    var body: some View {
        Map(position: .constant(.userLocation(fallback: .automatic))) {
                        // Add more
                    }
        .mapControls {
            MapUserLocationButton()
        }
        .padding()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(SkiingViewModel())
    }
}
