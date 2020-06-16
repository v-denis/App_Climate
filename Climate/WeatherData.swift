//
//  WeatherData.swift
//  Climate
//
//  Created by MacBook Air on 16.06.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
	
	let name: String
	let weather: [Weather]
	let main: Main
	let coord: Coordinates
}


struct Main: Decodable {
	
	let temp: Double
}

struct Coordinates: Decodable {
	
	let lon: Double
	let lat: Double
}

struct Weather: Decodable {
	
	let id: Int
	let main: String
	let description: String
	let icon: String
}
