//
//  ViewController.swift
//  ProjectPart2
//
//  Created by m2sar on 10/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.
//

import UIKit
import Weather
class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var btSearch: UIButton!
    @IBOutlet weak var weather5: UITextField!
    @IBOutlet weak var weatherTomo: UITextField!
    @IBOutlet weak var weather4: UITextField!
    @IBOutlet weak var weather3: UITextField!
    @IBOutlet weak var weatherText: UITextField!
    @IBOutlet weak var resultField: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!

    let client : WeatherClient = WeatherClient(key : "09ad0f0a8c3ec093a76ed8f85adfa134")
    override func viewDidLoad() {
        super.viewDidLoad()
    
    /*
    @IBAction func getWeather(_ sender: UITextField) {
        let city : City = client.citiesSuggestions(for: resultField.text!).first!
        client.weather(for: city) { (forecast) in
            self.resultField.text = city.name+" temp : "+(forecast?.temperature.description)!
            //print(forecast ?? "")
        }
        
    }
*/
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        let cityResult : [City] = client.citiesSuggestions(for: searchBar.text!)
        if sender==btSearch {
            view.endEditing(true)

            resultField.text = (cityResult.first?.name)!+" , "+(cityResult.first?.country)!
        
            fill(cityResult: cityResult)
            
    }
    
    
}
    // fill forecast boxes
    func fill(cityResult : [City]){
        client.forecast(for: (cityResult.first!), completion:{ (forecast: [Forecast]?) in
            if let forecast = forecast {
                DispatchQueue.main.async {
                
                self.weatherText.text = self.weatherString(forecast: forecast, i: 0)
                self.weatherTomo.text = self.weatherString(forecast: forecast, i: 1)
                self.weather3.text = self.weatherString(forecast: forecast, i: 2)
                self.weather4.text = self.weatherString(forecast: forecast, i: 3)
                self.weather5.text = self.weatherString(forecast: forecast, i: 4)
            }
            
        }
        })
        
    }
    // build forecast string
    func weatherString(forecast : [Forecast], i : Int) -> String{
        let today : String = "Today : "
        let deg : String = " °C"
        let tomo : String = "Tomorrow : "
        var result : String = ""
        if i==0 {
            result = today+((forecast[i].weather.first?.description)!)+" , "+(forecast[i].temperature.description)+deg
            
        }
        else if i==1 {
            result = tomo+((forecast[i].weather.first?.description)!)+" , "+(forecast[i].temperature.description)+deg
        
        }
        else {
            var realDate : String = forecast[i].date.description
            var tempDate = realDate.components(separatedBy: " ")
            let formatDate = tempDate[0]+" : "
            result = formatDate+((forecast[i].weather.first?.description)!)+" , "+(forecast[i].temperature.description)+deg
        }

        return result
        
        
        
    }
    
}
