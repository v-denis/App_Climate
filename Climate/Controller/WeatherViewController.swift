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
	@IBOutlet weak var forecastTableView: UITableView!
	@IBOutlet weak var todayLabel: UILabel!
	
	let activityIndicator = UIActivityIndicatorView(style: .medium)
	var weatherManager = WeatherManager()
	var forecastWeather = [ForecastWeatherModel]() {
		didSet {
			forecastWeather.removeFirst()
			forecastTableView.reloadData()
		}
	}
	let locationManager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		weatherManager.delegate = self
		searchTextField.delegate = self
		configuratingTableView()
		configureTapGesture()
		configuratingActivityIndicator()
		cityLabel.adjustsFontSizeToFitWidth = true
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		activityIndicator.startAnimating()
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
	}
	

	@IBAction func searchPressed(_ sender: UIButton? = nil) {
		searchTextField.endEditing(true)
	}
	
	@IBAction func locationPressed(_ sender: UIButton) {
		activityIndicator.startAnimating()
		locationManager.requestLocation()
	}
	
	private func configuratingActivityIndicator() {
		activityIndicator.color = UIColor(named: "weatherColor")
		activityIndicator.hidesWhenStopped = true
		searchTextField.addSubview(activityIndicator)
		activityIndicator.frame = CGRect(x: searchTextField.bounds.minX, y: searchTextField.bounds.minY, width: 35, height: searchTextField.frame.height)
	}
	
	private func configureTapGesture() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
		view.addGestureRecognizer(tapGesture)
	}
	
	private func configuratingTableView() {
		forecastTableView.dataSource = self
		forecastTableView.delegate = self
		forecastTableView.register(WeatherTableViewCell.nib, forCellReuseIdentifier: WeatherTableViewCell.reuseId)
		forecastTableView.separatorStyle = .none
		forecastTableView.allowsSelection = false
		
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
	
	func didUpdateForecastWeather(_ weatherManager: WeatherManager, forecast: [ForecastWeatherModel]) {
		forecastWeather = forecast
	}
	
	
	func didUpdateWeather(_ weatherManager: WeatherManager, with weather: WeatherModel) {
		temeratureLabel.text = weather.temperatureString
		cityLabel.text = weather.cityName
		conditionImageView.image = UIImage(systemName: weather.conditionString)
		todayLabel.text = weather.weekDay
	}
	
	func didFail(with error: Error) {
		if error.localizedDescription == "The Internet connection appears to be offline." {
			print("internet connection failed")
			changePlaceholder(in: searchTextField, for: 4, placeholderText: "No internet connection", textAfter: "City name")
			activityIndicator.stopAnimating()
		} else if error.localizedDescription == "The data couldn’t be read because it is missing." {
			print("missing data")
			changePlaceholder(in: searchTextField, for: 4, placeholderText: "Incorrect city name", textAfter: "Enter city name")
			activityIndicator.stopAnimating()
		} else {
			print(error.localizedDescription)
		}
		
	}
	
	func changePlaceholder(in textField: UITextField, for seconds: Int, placeholderText tempText: String, textAfter consistentText: String) {
		textField.placeholder = tempText
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
			textField.placeholder = consistentText
		}
	}
	
}


//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let lastLocation = locations.last {
			locationManager.stopUpdatingLocation()
			let lon = lastLocation.coordinate.longitude
			let lat = lastLocation.coordinate.latitude
			weatherManager.fetchWeather(withLongitude: lon, andLatitude: lat)
		}
		
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
}


//MARK: - UITableViewDelegate & UITableViewDataSource
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return forecastWeather.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.reuseId, for: indexPath) as! WeatherTableViewCell
		let currentDay = forecastWeather[indexPath.row]
		cell.updateUI(withDayName: currentDay.weekDay, imageName: currentDay.conditionString, minTemp: currentDay.minTempString, maxTemp: currentDay.maxTempString)
		if indexPath.row == forecastWeather.count - 1 {
			activityIndicator.stopAnimating()
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 45
	}
	
	
	
}
