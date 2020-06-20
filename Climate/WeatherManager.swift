//
//  WeatherManager.swift
//  Climate
//
//  Created by MacBook Air on 16.06.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate: class {
	func didUpdateForecastWeather(_ weatherManager: WeatherManager, forecast: [ForecastWeatherModel])
	func didUpdateWeather(_ weatherManager: WeatherManager, with weather: WeatherModel)
	func didFail(with error: Error)
}

struct WeatherManager {
	
	static let apiKey = ""
	let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
	let forCoordinatesURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)"
	let forecastWeatherURL = "https://api.openweathermap.org/data/2.5/onecall?exclude=hourly&appid=\(apiKey)&units=metric"
	
	weak var delegate: WeatherManagerDelegate?
	
	func fetchWeather(cityName: String) {
		let urlString = "\(weatherURL)&q=\(cityName)"
		makeRequest(with: urlString)
	}
	
	func fetchWeather(withLongitude longitude: Double, andLatitude latitude: Double) {
		let urlString = "\(weatherURL)&lon=\(longitude)&lat=\(latitude)"
		makeRequest(with: urlString)
	}

	
	private func fetchForecastWeather(forCoordinates coord: Coordinates) {
		let urlString = "\(forecastWeatherURL)&lon=\(coord.lon)&lat=\(coord.lat)"
		print(urlString)
		makeRequestForecastWeather(with: urlString)
	}
	
	func makeRequestForecastWeather(with urlString: String) {
		if let url = URL(string: urlString) {
			let session = URLSession(configuration: .default)
			let task = session.dataTask(with: url) { (data, response, error) in
				if error != nil {
					DispatchQueue.main.async {
						self.delegate?.didFail(with: error!)
					}
				}
				
				if let safeData = data {
					if let forecastWeather = self.parseForecastJSON(from: safeData) {
						DispatchQueue.main.async {
							self.delegate?.didUpdateForecastWeather(self, forecast: forecastWeather)
						}
					}
				}
				
			}
			task.resume()
		}
	}
	
	
	func makeRequest(with urlString: String) {
		
		if let url = URL(string: urlString) {
			let session = URLSession(configuration: .default)
			let task = session.dataTask(with: url) { (data, response, error) in
				if error != nil {
					DispatchQueue.main.async {
						self.delegate?.didFail(with: error!)
					}
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
			let dt = decodedData.dt
			let secondsGMT = decodedData.timezone
			fetchForecastWeather(forCoordinates: decodedData.coord)
			let weather = WeatherModel(cityName: city, conditionId: condition, temperature: temp, timeIntervalSince1970: dt, secondsFromGMT: secondsGMT)
			return weather
		} catch let error {
			DispatchQueue.main.async {
				self.delegate?.didFail(with: error)
			}
			return nil
		}
		
	}
	
	
	func parseForecastJSON(from jsonData: Data) -> [ForecastWeatherModel]? {
		
		let decoder = JSONDecoder()
		
		do {
			let decodedData = try decoder.decode(ForecastWeatherData.self, from: jsonData)
			let forecastData = decodedData.daily
			var resultArray = [ForecastWeatherModel]()
			for dayWeather in forecastData {

				let minimumTemp = dayWeather.temp.min
				let maximumTemp = dayWeather.temp.max
				let conditionId = dayWeather.weather[0].id
				let timeInterval = dayWeather.dt
				let zoneOffset = decodedData.timezone_offset


				let forecastWeather = ForecastWeatherModel(minTemp: minimumTemp, maxTemp: maximumTemp, conditionId: conditionId, timeIntervalSince1970: timeInterval, secondsFromGMT: zoneOffset)
				resultArray.append(forecastWeather)
			}
			return resultArray
		} catch let error {
			DispatchQueue.main.async {
				self.delegate?.didFail(with: error)
			}
			return nil
		}
	}
	
	
	
	
}
