//
//  ViewController.swift
//  weather
//
//  Created by frank on 2018/11/16.
//  Copyright © 2018 enhance. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {

    var todayObject: weather!
    var weekObject: [weather]!
    @IBOutlet weak var sunImageView: UIImageView!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var airLbl: UILabel!
    @IBOutlet weak var qualityLbl: UILabel!
    @IBOutlet weak var windImv: UIImageView!
    @IBOutlet weak var airImv: UIImageView!
    @IBOutlet weak var qualityImv: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.netWorkManager()
    }
    
    func netWorkManager() {
        let appcode = "APPCODE 691a8c4d415449ffb69b1a7ac2a4000d"

        let headers : HTTPHeaders = ["Authorization": appcode]


        Alamofire.request("http://weatherapi.market.alicloudapi.com/weather/TodayTemperatureByCity", method: .post, parameters: ["cityName":"北京"], encoding: URLEncoding.default, headers: headers).responseJSON { (response) in


            if let data = response.data, let utf8Text = String(data: data, encoding: String.Encoding.utf8) {
                print("Data: \(utf8Text)")

                
                let object = try?  JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                
                
                let dic = object?["result"] as! NSDictionary
                
                let dayModel = dic["today"] as! NSDictionary
                let skModel = dic["sk"] as! NSDictionary
                
                var todayDic = weather()
                todayDic.temperature = skModel["temp"] as! String
                todayDic.weather = dayModel["weather"] as! String
                todayDic.wind_strength = skModel["wind_strength"] as! String
                todayDic.week = dayModel["week"] as! String
                todayDic.city = dayModel["city"] as! String
                todayDic.uv_index = dayModel["uv_index"] as! String
                todayDic.humidity = skModel["humidity"] as! String
                
                self.todayObject = todayDic
                
                self.updateUI()
                
                let weekDic = dic["future"] as! NSDictionary
                
                let allValues = weekDic.allValues.sorted(by: { (key1, key2) -> Bool in
                    let dateDic1 = key1 as! NSDictionary
                    let dateDic2 = key2 as! NSDictionary
                    
                    let date1: Int = Int(dateDic1["date"] as! String)!
                    let date2: Int = Int(dateDic2["date"] as! String)!
                    
                    return date1 < date2
                    
                })
                
                var weekWeathers = [weather]()
                for value in allValues {
                    
                    var weekWeather = weather()
                    let dayDic = value as! NSDictionary
                    weekWeather.temperature = dayDic["temperature"] as! String
                    weekWeather.weather = dayDic["weather"] as! String
                    weekWeather.week = dayDic["week"] as! String
                    weekWeathers.append(weekWeather)
                }
                
                
                
                self.weekObject = weekWeathers
                
                
                self.collectionView.reloadData()
            }
        }
    }
    
    func dataToDictonary(data:Data) -> Dictionary<String, Any> {
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dic = json as! Dictionary<String, Any>
            return dic
        } catch _ {
            print("Nil")
            return Dictionary()
        }
    }
    
    func weatherImage(name: String) -> String {
        switch name {
        case "晴转多云":
            return "sun_b"
        case "多云转晴":
            return "sun_b"
        case "晴":
            return "sun_b"
        case "阴":
            return "yin_b"
        case "雪":
            return "snow_b_s"
        case "雾":
            return "fog_b"
        case "阵雨":
            return "snow_b_h"
        case "雷阵雨":
            return "leizhenyu_b"
        default:
            return "sun_b"
        }
    }
    
    func updateUI() {
        self.temperatureLbl.text = todayObject.temperature
        self.airLbl.text = todayObject.uv_index
        self.windLbl.text = todayObject.wind_strength
        self.qualityLbl.text = todayObject.humidity
        self.sunImageView.image = UIImage.init(named: self.weatherImage(name: todayObject.weather))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.weekObject == nil { return 0 }
        return self.weekObject.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: weatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! weatherCell
        
        cell.loadData(weather: weekObject[indexPath.row])
        
        return cell;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

