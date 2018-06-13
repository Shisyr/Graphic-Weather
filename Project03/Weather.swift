//
//  Weather.swift
//  Lesson01
//
//  Created by Шисыр Мухаммед Шарипович on 06.06.2018.
//  Copyright © 2018 Шисыр Мухаммед Шарипович. All rights reserved.
//
import UIKit
import SwiftyJSON

class Weather{
    var weather: Basic_info!
    struct Basic_info{
        var name_city: String!
        var id: String!
        var country: String!
        var population: String!
        var list: [List]
        init(json: JSON)
        {
            list = []
            name_city = json["city"]["name"].stringValue
            id = json["city"]["id"].stringValue
            country = json["city"]["country"].stringValue
            population = json["city"]["population"].stringValue
            for i in 0..<json["list"].count{
                let l = List(json: json["list"][i]);
                list.append(l);
            }
        }
    }
    struct List{
        var dt: String!
        var temp: Double!
        var temp_min: Double!
        var temp_max: Double!
        var pressure: String!
        var sea_level: String!
        var ground_level: String!
        var humidity: String!
        var temp_kf: String!
        var weather_id: String!
        var weather_main: String!
        var description_weather: String!
        var weather_icon: String!
        var cloud: String!
        var wind_degree: String!
        var wind_speed: String!
        var rain: String!
        var sys: String!
        var date: String!
        init(json: JSON) {
            dt = json["dt"].stringValue
            temp = json["main"]["temp"].double
            temp_min = json["main"]["temp_min"].double
            temp_max = json["main"]["temp_max"].double
            pressure = json["main"]["pressure"].stringValue
            sea_level = json["main"]["sea_level"].stringValue
            ground_level = json["main"]["grnd_level"].stringValue
            humidity = json["main"]["humidity"].stringValue
            temp_kf = json["main"]["temp_kf"].stringValue
            weather_id = json["weather"][0]["id"].stringValue
            weather_main = json["weather"][0]["main"].stringValue
            weather_icon = json["weather"][0]["icon"].stringValue
            description_weather = json["weather"][0]["description"].stringValue
            cloud = json["clouds"]["all"].stringValue
            wind_degree = json["wind"]["speed"].stringValue
            wind_speed = json["wind"]["deg"].stringValue
            rain = json["rain"]["3h"].stringValue
            sys = json["sys"]["pod"].stringValue
            date = json["dt_txt"].stringValue
        }
    }

    
    init()
    {
        getJSONData()
    }
    func getJSONData(){
        if let file = Bundle.main.path(forResource: "weather", ofType:"json")
        {
            do{
                let data = try Data(contentsOf: URL(fileURLWithPath: file), options: .alwaysMapped)
                let jsonObj = try JSON(data: data);
                weather = Basic_info(json: jsonObj)
            }
            catch let error{
                print("parse error: \(error.localizedDescription)")
            }
        }
        else{
            print("Invalid filename");
        }
    }
    func getData(index: Int) -> String{
        var data: String = ""
        data = ""
        data += " Country: " + weather.country
        data += "\n City: " + weather.name_city
        data += "\n ID: " + weather.id
        data += "\n Population: " + weather.population
        data += "\n Time: " + weather.list[index].date
        data += "\n DT: " + weather.list[index].dt
        data += "\n Weather_id: " + weather.list[index].weather_id
        data += "\n Weather: " + weather.list[index].weather_main
        data += "\n Description of weather: " + weather.list[index].description_weather
        data += "\n Temperature: " + String(format: "%.1f", weather.list[index].temp - 273.15) + " C"
        data += "\n Maximum temperature: " + String(format: "%.1f", weather.list[index].temp_max - 273.15) + " C"
        data += "\n Minimum temperature: " + String(format: "%.1f", weather.list[index].temp_min - 273.15) + " C"
        data += "\n Humidity: " + weather.list[index].humidity
        data += "\n Temp_KF: " + weather.list[index].temp_kf
        data += "\n Pressure: " + weather.list[index].pressure
        data += "\n Ground of Level: " + weather.list[index].ground_level
        data += "\n Sea level: " + weather.list[index].sea_level
        data += "\n Info of Rain: " + weather.list[index].rain
        data += "\n Wind: {degree: " + weather.list[index].wind_degree
        data += ", speed: " + weather.list[index].wind_speed + "}\n"
        return data
    }
}
