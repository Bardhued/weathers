//
//  weatherCell.swift
//  weather
//
//  Created by frank on 2018/11/17.
//  Copyright © 2018 enhance. All rights reserved.
//

import UIKit

class weatherCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var tianqiImv: UIImageView!
    @IBOutlet weak var temperatureLbl: UILabel!
    
    func loadData(weather: weather) {
        dayLbl.text = weather.week
        temperatureLbl.text = weather.temperature
        tianqiImv.image = UIImage.init(named: self.weatherImage(name: weather.weather))
    }
    
    func weatherImage(name: String) -> String {
        switch name {
        case "晴转多云":
            return "sun_s"
        case "多云转晴":
            return "sun_s"
        case "晴":
            return "sun_s"
        case "阴":
            return "yin_s"
        case "雪":
            return "snow_s_s"
        case "雾":
            return "fog_s"
        case "阵雨":
            return "zhenyu_s"
        case "雷阵雨":
            return "leizhenyu_s"
        default:
            return "sun_s"
        }
    }
    
}
