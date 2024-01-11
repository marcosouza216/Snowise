//
//  Resort.swift
//  Snowise
//
//  Created by Marco Souza on 9/1/2024.
//

import Foundation
struct ResortData: Codable {
    let data: Resort?
}

struct Resort: Codable {
    let slug, name, country, region: String
    let href: String
    let units: String
    let location: Location
    let lifts: Lifts?
    let conditions: Conditions?
}

struct Location: Codable {
    let latitude, longitude: Double
}

struct Lifts: Codable {
    let status: [String: String]
    let stats: LiftStats
}

struct LiftStats: Codable {
    let open, hold, scheduled, closed: Int
    let percentage: Percentage
}

struct Percentage: Codable {
    let open, hold, scheduled, closed: Double
}

struct Conditions: Codable {
    let base, season, twelveHours, twentyfourHours: Int
    let fortyeightHours, sevenDays: Int

    enum CodingKeys: String, CodingKey {
        case base, season
        case twelveHours = "twelve_hours"
        case twentyfourHours = "twentyfour_hours"
        case fortyeightHours = "fortyeight_hours"
        case sevenDays = "seven_days"
    }
}






// Define other structures as needed...


