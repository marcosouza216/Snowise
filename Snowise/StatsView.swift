import SwiftUI
import MapKit

struct StatsView: View {
    @EnvironmentObject private var viewModel: SkiingViewModel
    @State private var isMapViewActive = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    VStack(spacing: 20) {
                        // First row
                        HStack(spacing: 20) {
                            VStack {
                                Text("Speed")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .fixedSize()
                                Text("\(viewModel.speed, specifier: "%.2f") km/h")
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                                    .fixedSize()
                            }
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)

                            VStack {
                                Text("Max Speed")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .fixedSize()
                                Text("\(viewModel.maxSpeed, specifier: "%.2f") km/h")
                                    .font(.system(size: 30))
                                    .foregroundColor(.green)
                                    .fixedSize()
                            }
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)
                        }

                        // Second row
                        HStack(spacing: 20) {
                            VStack {
                                Text("Total")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .fixedSize()

                                Text("Distance")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .fixedSize()

                                Text("\(viewModel.totalDistance, specifier: "%.2f") meters")
                                    .font(.system(size: 30))
                                    .foregroundColor(.purple)
                                    .fixedSize()
                            }
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)

                            VStack {
                                Text("Duration")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .fixedSize()
                                Text("\(Int(viewModel.elapsedTime)) seconds")
                                    .font(.system(size: 30))
                                    .foregroundColor(.orange)
                                    .fixedSize()
                            }
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)
                        }

                        // Third row
                        HStack(spacing: 20) {
                            VStack {
                                Text("Altitude")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .fixedSize()
                                Text("\(viewModel.altitude, specifier: "%.2f") meters")
                                    .font(.system(size: 30))
                                    .foregroundColor(.red)
                                    .fixedSize()
                            }
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)
                        }

                        HStack(spacing: 20) {
                            Spacer()
                            Button(action: {
                                viewModel.startPauseRecording()
                            }) {
                                HStack {
                                    Image(systemName: viewModel.recordState == .recording ? "pause.circle.fill" : "play.circle.fill")
                                        .font(.system(size: 24))
                                    Text(viewModel.recordState == .recording ? "Pause" : "Start")
                                        .font(.headline)
                                }
                                .padding(12)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .scaleEffect(1.5)
                            }
                            Spacer()
                            Button(action: {
                                viewModel.stopRecording()
                            }) {
                                HStack {
                                    Image(systemName: "stop.circle.fill")
                                        .font(.system(size: 24))
                                    Text("Stop")
                                        .font(.headline)
                                }
                                .padding(12)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .scaleEffect(1.5)
                            }
                            Spacer()
                        }

                        NavigationLink(
                            destination: MapView().environmentObject(viewModel),
                            isActive: $isMapViewActive
                        ) {
                            EmptyView()
                        }
                        .hidden()

                        Map(position: .constant(.userLocation(fallback: .automatic))) {
                            // Add map content here
                        }
                        .mapControls {
                            MapUserLocationButton()
                        }
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .cornerRadius(10)
                        .onTapGesture {
                            isMapViewActive = true
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    Spacer()
                }
            }
            .navigationTitle("Stats")
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(SkiingViewModel())
    }
}
