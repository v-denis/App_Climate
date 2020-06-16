//
//  ViewController.swift
//  Climate
//
//  Created by MacBook Air on 10.06.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
	
	@IBOutlet weak var conditionImageView: UIImageView!
	@IBOutlet weak var temeratureLabel: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var searchTextField: UITextField!
	
	var weatherManager = WeatherManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		weatherManager.delegate = self
		searchTextField.delegate = self
	}

	@IBAction func searchPressed(_ sender: UIButton? = nil) {
		searchTextField.endEditing(true)
	}
	
}


//MARK: text field delegate methods
extension WeatherViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		searchPressed()
		return true
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if textField.text != "" {
			return true
		} else {
			textField.placeholder = "Type something here"
			return false
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		if let city = textField.text {
			weatherManager.fetchWeather(cityName: city)
		}
		searchTextField.text = ""
		textField.placeholder = "City name"
	}
	
}


//MARK: weather manager delegate methods
extension WeatherViewController: WeatherManagerDelegate {
	
	func didUpdateWeather(_ weatherManager: WeatherManager, with weather: WeatherModel) {
		temeratureLabel.text = weather.temperatureString
		cityLabel.text = weather.cityName
		conditionImageView.image = UIImage(systemName: weather.conditionString)
	}
	
	func didFail(with error: Error) {
		print(error)
	}
}

