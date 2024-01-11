import Foundation
import CoreLocation
import MapKit
import SwiftUI

class SkiingViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var pathLocations: [CLLocation] = []
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Published var speed: Double = 0
    @Published var maxSpeed: Double = 0
    @Published var totalDistance: Double = 0
    public var lastLocation: CLLocation?
    @Published var elapsedTime: TimeInterval = 0
    private var startTime: Date?
    @Published var altitude: Double = 0
    @Published var recordState: RecordState = .idle
    
    enum RecordState {
        case idle, recording, paused
    }
    
    override init() {
        super.init()
        setupLocationManager()
        
    }
   

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func updateMetrics(with location: CLLocation) {
        pathLocations.append(location)
        
        var speedValue = location.speed
        let threshold: Double = 1.000000000000001
        if abs(speedValue) < threshold {
            speedValue = 0
        }
        speed = speedValue * 3.6
        
        if speed > maxSpeed {
            maxSpeed = speed
        }
        
        if let lastLocation = lastLocation {
            let distance = lastLocation.distance(from: location)
            totalDistance += distance
        }
        lastLocation = location
        
        if startTime == nil {
            startTime = Date()
        }
        elapsedTime = Date().timeIntervalSince(startTime!)
        
        altitude = location.altitude
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Received location update: \(location.coordinate)")
        updateMetrics(with: location)
    }
    
    func startPauseRecording() {
        switch recordState {
        case .idle:
            locationManager.startUpdatingLocation()
            startTime = Date()
            recordState = .recording
        case .recording:
            locationManager.stopUpdatingLocation()
            recordState = .paused
            lastLocation = nil
        case .paused:
            locationManager.startUpdatingLocation()
            maxSpeed = 0
            //totalDistance = 0
            startTime = Date() - elapsedTime
            recordState = .recording
        }
    }

    func stopRecording() {
        locationManager.stopUpdatingLocation()
        recordState = .idle
        resetMetrics()
    }
    
    private func resetMetrics() {
        speed = 0
        maxSpeed = 0
        totalDistance = 0
        lastLocation = nil
        startTime = nil
        elapsedTime = 0
        altitude = 0
    }
    
    func updateMapRegion() {
        guard let firstLocation = pathLocations.first else { return }
        mapRegion.center = firstLocation.coordinate
    }
    func determineEmergencyNumber(for country: String?) -> String {
            guard let country = country else {
                // Default emergency number if country is not available
                return "112"
            }

            // Add conditions based on country to determine the appropriate emergency number
        switch country {
            case "France":
                return "112"
            case "United Kingdom":
                return "999"
            case "United States":
                return "911"
            case "Russia":
                return "112"
            case "Japan":
                return "119"
            case "Germany":
                return "112"
            case "Italy":
                return "112"
            case "Singapore":
                return "995"
            case "Sweden":
                return "112"
            case "Norway":
                return "112"
            case "Finland":
                return "112"
            case "China":
                return "110"
            case "India":
                return "112"
            case "Argentina":
                return "911"
            case "Chile":
                return "131"
            case "Saudi Arabia":
                return "112"
            case "South Korea":
                return "119"
            case "Iceland":
                return "112"
            case "Taiwan":
                return "110"
            case "Indonesia":
                return "112"
            case "South Africa":
                return "10111"
            case "Mexico":
                return "911"
            case "Turkey":
                return "112"
            case "Netherlands":
                return "112"
            case "Spain":
                return "112"
            case "Poland":
                return "112"
            case "Canada":
                return "911"
            case "Ukraine":
                return "112"
            case "Belgium":
                return "112"
            case "Denmark":
                return "112"
            case "Ireland":
                return "112"
            case "Slovenia":
                return "112"
            case "Latvia":
                return "112"
            case "Andorra":
                return "112"
            default:
                // Default emergency number if country is not within specified regions
                return "112"
            }
        }
    func requestLocationPermission() {
            locationManager.requestWhenInUseAuthorization()
        }

    func getCurrentCountry(completion: @escaping (String?) -> Void) {
        guard let lastLocation = lastLocation else {
            completion(nil)
            return
        }

        let geocoder = CLGeocoder()
        let locale = Locale.current  // 使用当前语言设置
        print("反向地理编码之前")
        geocoder.reverseGeocodeLocation(lastLocation, preferredLocale: locale) { (placemarks, error) in
            print("反向地理编码之")
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let placemark = placemarks?.first else {
                print("No placemarks found")
                completion(nil)
                return
            }

            guard let country = placemark.country else {
                print("No country information in the placemark")
                completion(nil)
                return
            }

            print("Determined country: \(country)")
            completion(country)
        }
    }

    func startUpdatingLocation() {
            locationManager.startUpdatingLocation()
        }
    

   
}


