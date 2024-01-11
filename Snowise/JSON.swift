//
//  JSON.swift
//  Snowise
//
//  Created by Marco Souza on 9/1/2024.
//

import Foundation
func loadResortData() -> ResortData? {
    guard let url = Bundle.main.url(forResource: "ResortData", withExtension: "json") else {
        print("ResortData.json not found.")
        return nil
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let resortData = try decoder.decode(ResortData.self, from: data)
        return resortData
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}
