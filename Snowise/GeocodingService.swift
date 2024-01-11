//
//  GeocodingService.swift
//  Snowise
//
//  Created by Marco Souza on 10/1/2024.
//

import Foundation
import Foundation

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

enum GeocodingError: Error {
    case invalidURL
    case noData
    case decodingError
}

struct GeocodingResult: Codable, Comparable {
    let lat: String?
    let lon: String?
    let type: String
    let display_name: String?
    let importance: Double?

    var coordinates: Coordinates? {
        guard let latitudeStr = lat, let longitudeStr = lon,
              let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) else {
            return nil
        }
        return Coordinates(latitude: latitude, longitude: longitude)
    }

    var isCity: Bool {
        return type.lowercased() == "city"
    }

    static func < (lhs: GeocodingResult, rhs: GeocodingResult) -> Bool {
        return (lhs.importance ?? 0) > (rhs.importance ?? 0)
    }
}

class GeocodingService {
    func getCoordinates(forCity city: String, completion: @escaping (Result<Coordinates, GeocodingError>) -> Void) {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("无效的城市名称")
            completion(.failure(.invalidURL))
            return
        }

        guard let url = URL(string: "https://geocode.maps.co/search?q=\(encodedCity)&api_key=658b3f66bbc1d442213972mdv73b6ad") else {
            print("无效的URL: https://geocode.maps.co/search?q=\(encodedCity)")
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("获取坐标时出错: \(error.localizedDescription)")
                completion(.failure(.invalidURL))
                return
            }

            guard let data = data else {
                print("未收到数据")
                completion(.failure(.noData))
                return
            }

            //print("Received JSON data:")
            print(String(data: data, encoding: .utf8) ?? "Unable to convert data to string.")

            do {
                let decoder = JSONDecoder()
                var results = try decoder.decode([GeocodingResult].self, from: data)

                // 对结果按照 importance 降序排序
                results.sort()

                if let firstResult = results.first {
                    print("Selected City: \(firstResult.display_name ?? "N/A")")
                    print("Latitude: \(firstResult.coordinates?.latitude ?? 0.0), Longitude: \(firstResult.coordinates?.longitude ?? 0.0)")

                    DispatchQueue.main.async {
                        completion(.success(firstResult.coordinates ?? Coordinates(latitude: 0.0, longitude: 0.0)))
                    }
                } else {
                    print("No valid results.")
                    completion(.failure(.noData))
                }
            } catch {
                print("解码数据时出错: \(error)")
                completion(.failure(.decodingError))
            }

        }.resume()
    }
}


