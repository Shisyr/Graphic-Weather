//
//  GraphicWeatherController.swift
//  Project03
//
//  Created by Шисыр Мухаммед Шарипович on 10.06.2018.
//  Copyright © 2018 Шисыр Мухаммед Шарипович. All rights reserved.
//

import UIKit
import Alamofire

struct Language: Decodable{
    let text: [String]
    
    init()
    {
        text = [String]()
    }
}

//struct Container{
//    let language: Language
//    let weather: GraphicWeather
//}
class GraphicWeatherController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
//    let weekdays = (Mon: "Понедельник", Tue: "Вторник", Wed: "Среда", Thu: "Четверг", Fri: "Пятница", Sat: "Суббота", Sun:"Воскресенье")
//    let english_weather = ["light rain", "few clouds", "clear sky", "broken clouds", "moderate rain", "scattered clouds"]
//    let russian_weather = ["Легкий дождь", "", "Безоблачно", ]
//    let weekda
    
    @IBOutlet weak var weekWeatherCollectionView: UICollectionView!
    @IBOutlet weak var image_weather: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var description_weather: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var temperature: UILabel!
    var weather = GraphicWeather()
    let dateFormatter = DateFormatter()
    let dateFormatterPrint = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        initDate()
  
        weekWeatherCollectionView.reloadData()

    }
    func initDate()
    {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        getParseJSON{ response in
            let Innerdate = self.dateFormatter.date(from: (response.list[1].dt_txt))!
            self.dateFormatterPrint.locale = Locale(identifier: "ru_RU")
            self.dateFormatterPrint.weekdaySymbols = self.dateFormatterPrint.weekdaySymbols.map{$0.localizedCapitalized}
            self.dateFormatterPrint.dateFormat = "EEE,dd MMM"
            self.dateFormatterPrint.monthSymbols = self.dateFormatterPrint.monthSymbols.map{$0.localizedCapitalized}
            self.dateFormatterPrint.dateStyle = .full
            self.date.text = self.dateFormatterPrint.string(from: Innerdate)
            print("today is \(self.dateFormatter.string(from: Innerdate))");
            self.translate(text: (response.list[1].weather[0].description)){result in
                self.description_weather.text = (result.capitalized)
            }
            self.translate(text: response.city.name){ result in
                self.place.text = (result.capitalized)
            }
        }
    }
    
    func translate(text: String?, completionHandler: @escaping (String) -> Void)
    {
        var url = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20180612T115645Z.27b8da6bb3c85a30.3d182c296ad33041b7529dd42aa1726db59255fc&text=\(text!)&lang=en-ru"
        url = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        Alamofire_Request(isFirst: false, url: url){ resGW, resL in
            print("After translation \((resL.text[0]))")
            completionHandler(resL.text[0])
        }

    }

    func getParseJSON(completionHandler: @escaping (GraphicWeather.Graphic_Weather) -> Void)
    {
        let url = "https://api.openweathermap.org/data/2.5/forecast?lat=42.874722&lon=74.612222&APPID=079587841f01c6b277a82c1c7788a6c3"
        Alamofire_Request(isFirst: true, url: url){ responseGW, responseL in
            completionHandler(responseGW)
        }

    }

    func Alamofire_Request(isFirst: Bool, url: String, completionHandler: @escaping (GraphicWeather.Graphic_Weather, Language) -> Void)
    {
        Alamofire.request(url).responseJSON { response in
            guard response.result.isSuccess else {
                print("Ошибка при запросе данных \(String(describing: response.result.error))")
                return
            }
            do{
                if(isFirst)
                {
                   let data = try JSONDecoder().decode(GraphicWeather.Graphic_Weather.self, from: response.data!)
                    completionHandler(data, Language())
                }
                else{
                   let data = try JSONDecoder().decode(Language.self, from: response.data!)
                    completionHandler(GraphicWeather.Graphic_Weather(), data)
                }
            }
            catch(let jsonErr)
            {
                print("Ошибка состоит из \(jsonErr)")
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekWeatherCollectionViewCell", for: indexPath) as! WeekWeatherCollectionViewCell

        print("indexPath: \(indexPath.row)")
        let nameWeeks = getNameOfDays()
        var today = Date()
        getTempOfDays();
        today.addTimeInterval(3600 * 6)
        cell.day.text = nameWeeks[indexPath.row]
        cell.dayTimeTemp.text = "29 C"
        return cell
    }
    
    
    func getTempOfDays() -> [Double]
    {
        let today = self.dateFormatter.string(from: Date());
        print("TODAY \(today)");
        var tempOfWeeks = [Double]()
//        getParseJSON{response in
//            print(response);
//                    var indexWeeks = 1
//                    print("In getParseJSON");
//                    for i in 0..<response.list.count{
//                        let date = self.dateFormatter.date(from: response.list[i].dt_txt)
//                        self.dateFormatterPrint.dateFormat = "EEEE"
//                        let nextDay = self.dateFormatterPrint.string(from: date!)
//                        print("Next day is \(nextDay)")
//                        if(nameWeeks[indexWeeks] == nextDay)
//                        {
//                            print("\(nextDay) has such weather: \(response.list[i].main.temp)")
//                            cell.dayTimeTemp.text = String(format: "%.1f", response.list[i].main.temp - 273.15)
//                            indexWeeks += 1
//                        }
//                    }
      //  }
        
        return tempOfWeeks
    }
    func getNameOfDays() -> [String]
    {
        var weeks = [String]()
        weeks.append("Сегодня")
        self.dateFormatterPrint.dateFormat = "EEEE"
        self.dateFormatterPrint.locale = Locale(identifier: "ru_RU")
        self.dateFormatterPrint.weekdaySymbols = self.dateFormatterPrint.weekdaySymbols.map{$0.localizedCapitalized}
        var dates = Date()
        for _ in 0..<6{
            dates.addTimeInterval(3600 * 24)
            weeks.append(dateFormatterPrint.string(from: dates))
        }
        return weeks
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
