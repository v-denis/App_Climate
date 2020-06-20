//
//  WeatherTableViewCell.swift
//  Climate
//
//  Created by MacBook Air on 18.06.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

	@IBOutlet weak var dayNameLabel: UILabel!
	@IBOutlet weak var weatherImageView: UIImageView!
	@IBOutlet weak var maxTemperatLabel: UILabel!
	@IBOutlet weak var minTemperatLabel: UILabel!
	
	static let reuseId = String(describing: WeatherTableViewCell.self)
	static let nib = UINib(nibName: String(describing: WeatherTableViewCell.self), bundle: nil)
	
	override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	func updateUI(withDayName dayName: String, imageName: String, minTemp: String, maxTemp: String) {
		self.dayNameLabel.text = dayName
		self.weatherImageView.image = UIImage(systemName: imageName)
		self.maxTemperatLabel.text = maxTemp
		self.minTemperatLabel.text = minTemp
	}
    
}
