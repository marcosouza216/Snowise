//
//  APICall.swift
//  Snowise
//
//  Created by Marco Souza on 9/1/2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    func fetchResortData(forResortName resortName: String, completion: @escaping (Result<ResortData, Error>) -> Void) {
        let headers = [
            "X-RapidAPI-Key": "458591a03emshb7e509ecf5cedd9p11efc2jsn1206cfd6612b",
            "X-RapidAPI-Host": "ski-resorts-and-conditions.p.rapidapi.com"
        ]
        

        let request = NSMutableURLRequest(url: NSURL(string: "https://ski-resorts-and-conditions.p.rapidapi.com/v1/resort/\(resortName)")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Received data: \(dataString)")
                }
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(ResortData.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }

        dataTask.resume()
    }
}


