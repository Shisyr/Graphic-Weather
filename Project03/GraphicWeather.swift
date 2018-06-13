//
//  GraphicWeather.swift
//  Project03
//
//  Created by Шисыр Мухаммед Шарипович on 10.06.2018.
//  Copyright © 2018 Шисыр Мухаммед Шарипович. All rights reserved.
//

import UIKit
import Alamofire

class GraphicWeather {
    struct Graphic_Weather: Decodable{
        let list: [List]
        let city: City
        init() {
            city = City()
            list = [List]()
        }
    }
    struct List: Decodable{
        let main: Main
        let weather: [GWeather]
        let dt_txt: String
        
        init() {
           main = Main()
            weather = [GWeather]()
           dt_txt = ""
        }
    }
    struct GWeather: Decodable{
        let main: String
        let description: String
        init() {
            main = ""
            description = ""
        }
    }
    struct Main: Decodable{
        let temp: Double
        init() {
            temp = 0.0
        }
        
    }
    struct City: Decodable{
        let name: String
        init() {
            name = ""
        }
    }
}
