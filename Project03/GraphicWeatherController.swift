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
}
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
    override func viewDidLoad() {
        super.viewDidLoad()
        initDate()
  
        //weekWeatherCollectionView.reloadData()

    }
    func initDate()
    {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        getParseJSON{ response in
            let Innerdate = self.dateFormatter.date(from: (response?.list[1].dt_txt)!)!
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "EEE,dd MMM"
            dateFormatterPrint.locale = Locale(identifier: "ru_RU")
            dateFormatterPrint.weekdaySymbols = dateFormatterPrint.weekdaySymbols.map{$0.localizedCapitalized}
            dateFormatterPrint.monthSymbols = dateFormatterPrint.monthSymbols.map{$0.localizedCapitalized}
            dateFormatterPrint.dateStyle = .full
            self.date.text = dateFormatterPrint.string(from: Innerdate)
            print("today is \(Innerdate)");
            self.translate(text: "light rain"){ res in
                print(res)
            }
//            print(response!.list[1].weather[0].description)
//            self.translate(text: (response!.list[1].weather[0].description)){result in
//                print(result)
//
////                self.description_weather.text = result!
//            }
        }
    }
    
    func translate(text: String?, completionHandler: @escaping (String?) -> Void)
    {
        
        print("What's wrong? \(text!)")
        // text! = light rain
        let url = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20180612T115645Z.27b8da6bb3c85a30.3d182c296ad33041b7529dd42aa1726db59255fc&text=\(text!)&lang=en-ru"
        
        //        let url = URL(string: "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20180612T115645Z.27b8da6bb3c85a30.3d182c296ad33041b7529dd42aa1726db59255fc&text=\(text!)&lang=en-ru") as! URL
        print(url)
        Alamofire.request(url).responseJSON { response in
            do{
                print(response.value)
                //let data = try JSONDecoder().decode(Language.self, from: response.data!)
//                print(data.text[0])
                completionHandler(response.value as! String)
            }
            catch(let jsonErr)
            {
                print("Ошибка \(jsonErr)")
            }
        }
    }
    func getParseJSON(completionHandler: @escaping (GraphicWeather.Graphic_Weather?) -> Void)
    {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=42.874722&lon=74.612222&APPID=079587841f01c6b277a82c1c7788a6c3")
        Alamofire.request(url!).responseJSON { response in
            guard response.result.isSuccess else {
                print("Ошибка при запросе данных \(String(describing: response.result.error))")
                return
            }
            do{
                let result = response.data
                
                let data = try JSONDecoder().decode(GraphicWeather.Graphic_Weather.self, from: result!)
//                self.translate(text: data.city.name){ res in
//                    print("Res: \(res!)")
//                    self.place.text = res
//                }
//                self.translate(text: data.city.name){ res in
//                    print(res)
////                    self.place.text = result
//                }
                completionHandler(data)
            }   catch(let jsonErr)
            {
                print("Error \(jsonErr)");
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekWeatherCollectionViewCell", for: indexPath) as! WeekWeatherCollectionViewCell

        cell.dayTime.text = "День:"
        cell.nightTime.text = "Ночь:"
        
        if(indexPath.row == 0)
        {
            cell.day.text = "Сегодня"
            cell.dayTimeTemp.text = ""
            cell.nightTImeTemp.text = ""
        }
        else{
            
            getParseJSON{ response in
//                let today = self.dateFormatter.date(from: (response?.list[1].dt_txt)!)
//                let nextDay = self.dateFormatter.date(from: (response?.list[indexPath.row].dt_txt)!)
//                print(today?.timeIntervalSince(nextDay!))
                cell.dayTimeTemp.text = String(format: "%.1f", (response?.list[1].main.temp)!)
                cell.nightTImeTemp.text = String(format: "%.1f", (response?.list[1].main.temp)!)
            }
        }
//        cell.day.text = weekdays[indexPath.row]
        
        return cell
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
