//
//  ResortView.swift
//  Snowise
//
//  Created by Marco Souza on 9/1/2024.
//

import SwiftUI

import SwiftUI

struct ResortView: View {
    @State private var resortData: ResortData?
    @State private var resortName: String = ""
    @State private var errorMessage: String?
    @ObservedObject var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationView {
            List {
                TextField("Enter Resort Name", text: $resortName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Search") {
                    //resortData = loadResortData()
                    NetworkManager.shared.fetchResortData(forResortName: resortName) { result  in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let data):
                                self.resortData = data
                                print("Data successfully fetched: \(data)")
                            case .failure(let error):
                                self.errorMessage = error.localizedDescription
                                print("Fail")
                            }
                        }
                    }
                    viewModel.getWeatherData(forCity: resortName)
                }
                .padding()
                
                if let resort = resortData?.data {
                    DisclosureGroup("Resort Information") {
                        Text("Name: \(resort.name)")
                        Text("Country: \(resort.country)")
                        Text("Region: \(resort.region)")
                    }
                    .padding()
                    if let conditions = resort.conditions{
                        DisclosureGroup("Snow Conditions") {
                            Text("Base: \(conditions.base) cm")
                            Text("24 Hours: \(conditions.twentyfourHours) cm")
                            Text("7 days: \(conditions.sevenDays) cm")
                            // Add other snow condition details as needed
                        }
                        .padding()
                    }
                    if let lifts = resort.lifts{
                        DisclosureGroup("Lifts Status") {
                            Text("Open: \(lifts.stats.open)")
                            ForEach(lifts.status.sorted(by: <), id: \.key) { key, value in
                                Text("\(key): \(value)")
                            }
                        }
                        .padding()
                    }
                }
                
                if let weather = viewModel.weather {
                    DisclosureGroup("Weather Details") {
//                        if let selectedCity = viewModel.selectedCity {
//                            Text("City: \(selectedCity)")
//                        }
                        ForEach(weather.daily.time.indices, id: \.self) { index in
                            VStack(alignment: .leading) {
                                Text("\(weather.daily.time[index])")
                                Text(String(format:" %.1f°C to %.1f°C", weather.daily.temperature_2m_min[index], weather.daily.temperature_2m_max[index]))
                                Image(systemName: viewModel.weatherCodeToSFString(weather.daily.weather_code[index]))
                                    .font(.system(size: 50))
                            }
//                            .padding(.vertical)
                        }
                    }
                    .padding()
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                }
            }
            .navigationBarTitle("Resort Details")
        }
    }
}
