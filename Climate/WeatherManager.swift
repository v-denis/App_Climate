//
//  WeatherManager.swift
//  Climate
//
//  Created by MacBook Air on 16.06.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate: class {
	func didUpdateWeather(_ weatherManager: WeatherManager, with weather: WeatherModel)
	func didFail(with error: Error)
}

struct WeatherManager {
	
	let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ca1e3566452b006fd066152d8fba22a6&units=metric"
	weak var delegate: WeatherManagerDelegate?
	
	func fetchWeather(cityName: String) {
		let urlString = "\(weatherURL)&q=\(cityName)"
		makeRequest(with: urlString)
	}
	
	func makeRequest(with urlString: String) {
		
		if let url = URL(string: urlString) {
			let session = URLSession(configuration: .default)
			let task = session.dataTask(with: url) { (data, response, error) in
				if error != nil {
					self.delegate?.didFail(with: error!)
					return
				}
				
				if let safeData = data {
					if let fetchedWeather = self.parseJSON(from: safeData) {
						DispatchQueue.main.async {
							self.delegate?.didUpdateWeather(self, with: fetchedWeather)
						}
					} else {
						print("Can't parse the JSON")
					}
				}
			}
			task.resume()
		}
		
	}
	
	func parseJSON(from jsonData: Data) -> WeatherModel? {
		
		let decoder = JSONDecoder()
		
		do {
			let decodedData = try decoder.decode(WeatherData.self, from: jsonData)
			let city = decodedData.name
			let condition = decodedData.weather[0].id
			let temp = decodedData.main.temp
			
			let weather = WeatherModel(cityName: city, conditionId: condition, temperature: temp)
			return weather
		} catch let error {
			delegate?.didFail(with: error)
			return nil
		}
		
	}
	
	
}
