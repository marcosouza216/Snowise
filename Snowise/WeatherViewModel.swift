//
//  WeatherViewModel.swift
//  Snowise
//
//  Created by Marco Souza on 10/1/2024.
//

import Foundation
class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherModel?
    @Published var cityResults: [GeocodingResult] = []
    @Published var selectedCity: String?
    let geocodingService = GeocodingService()
    
    // 将 WMO 天气代码映射到 SF Symbols 图标名称
    func weatherCodeToSFString(_ code: Int) -> String {
            switch code {
            case 0: return "clear"
            case 1, 2, 3: return "cloud.sun"
            case 45, 48: return "cloud.fog"
            case 51, 53, 55: return "cloud.drizzle"
            case 56, 57: return "cloud.sleet"
            case 61, 63, 65: return "cloud.rain"
            case 66, 67: return "cloud.sleet"
            case 71, 73, 75: return "cloud.snow"
            case 77: return "cloud.snow"
            case 80, 81, 82: return "cloud.heavyrain"
            case 85, 86: return "cloud.heavysnow"
            case 95: return "cloud.bolt.rain"
            case 96, 99: return "cloud.bolt.hail"
            default: return "questionmark.diamond"
            }
        }
    func getWeatherData(forCity city: String) {
        geocodingService.getCoordinates(forCity: city) { result in
            switch result {
            case .success(let coordinates):
                //print("Successfully obtained coordinates for city: \(city)")
                self.selectedCity = city
                
                    self.fetchWeatherData(latitude: coordinates.latitude, longitude: coordinates.longitude)
                
            case .failure(let error):
                print("Error fetching coordinates: \(error.localizedDescription)")
            }
        }
    }

    func fetchWeatherData(latitude: Double, longitude: Double) {
            let apiUrl = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=weather_code,temperature_2m_max,temperature_2m_min")!

            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)

            let task = session.dataTask(with: apiUrl) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    print("Data received successfully.")
                    print("Received JSON data:")
                    print(String(data: data, encoding: .utf8) ?? "Unable to convert data to string.")

                    if let weather = self.parseWeatherData(data: data) {
                        DispatchQueue.main.async {
                            self.objectWillChange.send()
                            self.weather = weather
                        }
                    } else {
                        print("Error parsing weather data.")
                    }
                }
            }

            print(apiUrl)

            task.resume()
        }

        func parseWeatherData(data: Data) -> WeatherModel? {
            do {
                let decoder = JSONDecoder()
                let weather = try decoder.decode(WeatherModel.self, from: data)
                return weather
            } catch {
                print("Error decoding weather data: \(error.localizedDescription)")
                print("Failed to decode JSON data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string.")")
                return nil
            }
        }
    
    }

