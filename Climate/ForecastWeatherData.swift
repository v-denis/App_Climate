//
//  ForecastWeatherModel.swift
//  Climate
//
//  Created by MacBook Air on 18.06.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation

struct ForecastWeatherData: Decodable {
	
	let lat: Double
	let lon: Double
	let current: CurrentWeather
	let daily: [DailyWeather]
	let timezone_offset: Int
}

struct CurrentWeather: Decodable {
	let dt: Int
	let temp: Double
	let weather: [Weather]
	
}


struct DailyWeather: Decodable {
	let dt: Int
	let temp: Temperature
	let weather: [Weather]
}

struct Temperature: Decodable {
	let min: Double
	let max: Double
}


