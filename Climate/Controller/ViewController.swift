//
//  ViewController.swift
//  Climate
//
//  Created by MacBook Air on 10.06.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var conditionImageView: UIImageView!
	@IBOutlet weak var temeratureLabel: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var searchTextField: UITextField!
	
	let weatherManager = WeatherManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		searchTextField.delegate = self
	}

	@IBAction func searchPressed(_ sender: UIButton? = nil) {
		searchTextField.endEditing(true)
	}
	
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
	}
	
}

