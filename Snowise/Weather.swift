//
//  Weather.swift
//  Snowise
//
//  Created by Marco Souza on 10/1/2024.
//

import Foundation
struct WeatherModel: Codable {
    struct Daily: Codable {
        let time: [String]
        let weather_code: [Int]
        let temperature_2m_max: [Double]
        let temperature_2m_min: [Double]
    }

    struct DailyUnits: Codable {
        let time: String
        let weather_code: String
        let temperature_2m_max: String
        let temperature_2m_min: String
    }

    let latitude: Double
    let longitude: Double
    let generationtime_ms: Double
    let utc_offset_seconds: Int
    let timezone: String
    let timezone_abbreviation: String
    let elevation: Double
    let daily_units: DailyUnits
    let daily: Daily
}
