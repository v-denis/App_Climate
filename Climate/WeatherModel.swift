//
//  WeatherModel.swift
//  Climate
//
//  Created by MacBook Air on 16.06.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation

struct WeatherModel {
	
	let cityName: String
	let conditionId: Int
	let temperature: Double
	private let timeIntervalSince1970: Int
	private let secondsFromGMT: Int
	
	var weekDay: String {
		let timeFormatter = DateFormatter()
		timeFormatter.dateFormat = "EEEE"
		timeFormatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
		let dateSince1970 = Date(timeIntervalSince1970: TimeInterval(timeIntervalSince1970))
		return timeFormatter.string(from: dateSince1970)
	}
	
	var temperatureString: String {
		return String(format: "\(temperature.getSign)%.f", temperature)
	}
	
	var conditionString: String {
		switch conditionId {
			case 200...232: return "cloud.bolt.rain"
			case 300...321: return "cloud.drizzle"
			case 500...502: return "cloud.rain"
			case 503...504: return "cloud.heavyrain"
			case 511: return "snow"
			case 520...531: return "cloud.sleet"
			case 602: return "cloud.snow.fill"
			case 615...616: return "cloud.sleet.fill"
			case 600, 601, 611..<615, 620...622: return "snow"
			case 701...771: return "wind"
			case 781: return "tornado"
			case 800: return "sun.max"
			case 801: return "cloud.sun"
			case 802: return "cloud"
			case 803...804: return "smoke.fill"
			default: return "thermometer"
		}
	}
	
	public init(cityName: String, conditionId: Int, temperature: Double, timeIntervalSince1970: Int, secondsFromGMT: Int) {
		self.cityName = cityName
		self.conditionId = conditionId
		self.temperature = temperature
		self.timeIntervalSince1970 = timeIntervalSince1970
		self.secondsFromGMT = secondsFromGMT
	}
	
}

extension Double {
	
	var getSign: String {
		if self == 0 {
			return ""
		} else if self > 0 {
			return "+"
		} else {
			return "-"
		}
	}
}
