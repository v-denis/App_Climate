//
//  WeatherManager.swift
//  Climate
//
//  Created by MacBook Air on 16.06.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation

struct WeatherManager {
	
	let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ca1e3566452b006fd066152d8fba22a6&units=metric"
	
	func fetchWeather(cityName: String) {
		let urlString = "\(weatherURL)&q=\(cityName)"
		makeRequest(urlString: urlString)
	}
	
	func makeRequest(urlString: String) {
		
		if let url = URL(string: urlString) {
			let session = URLSession(configuration: .default)
			let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
			task.resume()
		}
		
	}
	
	func handle(data: Data?, response: URLResponse?, error: Error?) -> Void {
		
		if error != nil {
			print(error!.localizedDescription)
			return
		}
		
		if data != nil {
			let stringData = String(data: data!, encoding: .utf8)
			print(stringData!)
		}
		
	}
	
}
