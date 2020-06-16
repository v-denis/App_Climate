//
//  ViewController.swift
//  Climate
//
//  Created by MacBook Air on 10.06.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
	
	@IBOutlet weak var conditionImageView: UIImageView!
	@IBOutlet weak var temeratureLabel: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var searchTextField: UITextField!
	
	let activityIndicator = UIActivityIndicatorView(style: .medium)
	var weatherManager = WeatherManager()
	let locationManager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		weatherManager.delegate = self
		searchTextField.delegate = self
		
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
		configureTapGesture()
		activityIndicator.color = UIColor(named: "weatherColor")
		activityIndicator.hidesWhenStopped = true
		searchTextField.addSubview(activityIndicator)
		activityIndicator.frame = CGRect(x: searchTextField.bounds.minX, y: searchTextField.bounds.minY, width: 35, height: searchTextField.frame.height)
//		activityIndicator.frame = searchTextField.bounds
	}

	@IBAction func searchPressed(_ sender: UIButton? = nil) {
		searchTextField.endEditing(true)
	}
	
	@IBAction func locationPressed(_ sender: UIButton) {
		
		locationManager.requestLocation()
	}
	
	private func configureTapGesture() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
		view.addGestureRecognizer(tapGesture)
	}
	
	@objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
		searchTextField.endEditing(true)
	}
}


//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		searchPressed()
		return true
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if textField.text != "" {
			return true
		} else if textField.placeholder == "Type something here" {
			return true
		} else {
			textField.placeholder = "Type something here"
			return false
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		guard textField.text != "" else {
			textField.placeholder = "City name"
			return }
		if let city = textField.text {
			activityIndicator.startAnimating()
			weatherManager.fetchWeather(cityName: city)
		}
		searchTextField.text = ""
		textField.placeholder = "City name"
	}
	
}


//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
	
	func didUpdateWeather(_ weatherManager: WeatherManager, with weather: WeatherModel) {
		activityIndicator.stopAnimating()
		temeratureLabel.text = weather.temperatureString
		cityLabel.text = weather.cityName
		conditionImageView.image = UIImage(systemName: weather.conditionString)
	}
	
	func didFail(with error: Error) {
		print(error)
	}
}


//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let lastLocation = locations.last {
			locationManager.stopUpdatingLocation()
			let lon = lastLocation.coordinate.longitude
			let lat = lastLocation.coordinate.latitude
			activityIndicator.startAnimating()
			weatherManager.fetchWeather(withLongitude: lon, andLatitude: lat)
		}
		
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
}
