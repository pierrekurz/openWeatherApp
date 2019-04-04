import Cocoa
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let weatherUrl: String = "https://api.openweathermap.org/data/2.5/weather"
let forecastUrl: String = "https://api.openweathermap.org/data/2.5/forecast"
let APIKEY : String = "09ad0f0a8c3ec093a76ed8f85adfa134"

extension URL {
    
    func withQueries(_ queries: [String: String]) -> URL? {//construction de l'url avec queries
        
        var components = URLComponents(url: self,
                                       
                                       resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map {
            
            URLQueryItem(name: $0.0, value: $0.1)
        }
        return components?.url
    }
}
struct CurrentWeather: Codable {
    
    struct Weather: Codable {
        let main: String
        let description: String
        
        enum MyStructKeys: String, CodingKey {
            case main = "main"
            case description = "description"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: MyStructKeys.self)
            self.main = try container.decode(String.self, forKey: MyStructKeys.main)
            self.description = try container.decode(String.self, forKey: MyStructKeys.description)
        }
        
        init() {
            self.main = ""
            self.description = ""
        }
    }
    struct Main : Codable {
        let temp : Float
        let pressure : Float
        let humidity : Float
        let temp_min : Float
        let temp_max : Float
        
        enum MyStructKeys: String, CodingKey {
            case temp,pressure,humidity,temp_min,temp_max
            
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: MyStructKeys.self)
            self.temp = try container.decode(Float.self, forKey: .temp)
            self.pressure = try container.decode(Float.self, forKey: .pressure)
            self.humidity = try container.decode(Float.self, forKey: .humidity)
            self.temp_min = try container.decode(Float.self, forKey: .temp_min)
            self.temp_max = try container.decode(Float.self, forKey : .temp_max)
            
        }
        init(){
            self.temp=0.0
            self.pressure=0.0
            self.humidity=0.0
            self.temp_min=0.0
            self.temp_max=0.0
        }
        
        
    }
    
    let weather: [Weather]
    let main: Main
    let name: String
    
    enum MyStructKeys: String, CodingKey {
        case weather, main, name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self)
        self.weather = try container.decodeIfPresent([Weather].self, forKey: .weather) ?? [Weather()]
        self.main = try container.decodeIfPresent(Main.self, forKey: .main) ?? Main()
        self.name = try container.decode(String.self, forKey: .name)
    }
}
    
    ///////////////////
    

struct Forecast: Codable {
    
    struct List : Codable {
        
        struct Main : Codable {
            let temp : Float
            let pressure : Float
            let humidity : Int
            
            enum MyStructKeys: String, CodingKey {
                case temp
                case pressure
                case humidity
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: MyStructKeys.self)
                self.temp = try container.decode(Float.self, forKey: .temp)
                self.pressure = try container.decode(Float.self, forKey: .pressure)
                self.humidity = try container.decode(Int.self, forKey: .humidity)
            
        }
            init(){
                self.temp=0.0
                self.pressure=0.0
                self.humidity=0
            }
            
        }

        struct Weather : Codable{
            let main : String
            let description : String
            
        
        enum MyStructKeys: String, CodingKey {
            case main = "main"
            case description = "description"
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: MyStructKeys.self)
            self.main = try container.decode(String.self, forKey: .main)
            self.description = try container.decode(String.self, forKey: .description)
            
        }
        init(){
            self.main=""
            self.description=""
        }
            
        }
    
        
        let list : [List]
        let main: Main
        let weather: Weather
        enum MyStructKeys: String, CodingKey {
            case list,main,weather
        }
        
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: MyStructKeys.self)
            self.list = (try container.decode([List].self, forKey: .list)) ?? [List()]
            self.main = try container.decode(Main.self, forKey: .main) ?? Main()
            self.weather = try container.decode(Weather.self, forKey: .weather)
        }
        init(){
            self.list = [List()]
            self.main = Main()
            self.weather = Weather()
        }
    }

}

/////////////


// fonction pour recuperer la meteo d'une ville a partir de son id
func getWeatherById(cityId : String){
    let query: [String: String] = [
        "id": cityId,
        "APPID": APIKEY
    ]
    
    let url = URL(string : weatherUrl)!.withQueries(query)!
    
    let task = URLSession.shared.dataTask(with: url) { (data,
        
        response, error) in
        
        let decoder = JSONDecoder()
        
        
        if let data = data { // le resultat du call
            
            let currentWeather = try! decoder.decode(CurrentWeather.self,from: data)
            
            print("Weather for city : \(currentWeather.name)")
            print("Average temperature : \(currentWeather.main.temp) Kelvin")
            print("Description : \(currentWeather.weather[0].description)")
            print("Humidity : \(currentWeather.main.humidity) %")
            print("Pressure : \(currentWeather.main.pressure) hPa")
            print("***************")
        }
        
    }
    task.resume()
}

// fonction pour recuperer la meteo d'une ville a partir de son nom
func getWeatherByName(city : String){
    let query: [String: String] = [
        "q": city,
        "APPID": APIKEY
    ]
    
    let url = URL(string : weatherUrl)!.withQueries(query)!
    
    let task = URLSession.shared.dataTask(with: url) { (data,
        
        response, error) in
        
        let decoder = JSONDecoder()
        
        if let data = data { // le resultat du call
            
            let currentWeather = try! decoder.decode(CurrentWeather.self,from: data)
            
            print("Weather for city : \(currentWeather.name)")
            print("Average temperature : \(currentWeather.main.temp) Kelvin")
            print("Description : \(currentWeather.weather[0].description)")
            print("Humidity : \(currentWeather.main.humidity) %")
            print("Pressure : \(currentWeather.main.pressure) hPa")
            print("***************")


            
        }
        //if let response = response {
        //print(response) // le header de la reponse
        //}
    }
    task.resume()
}
func findCityId (cityName: String, cityDic: [String: String]) -> String? {
    if let cityId = cityDic[cityName] {
        return cityId;
    } else {
        print("City could not be found");
        return nil;
    }
}

func findCityIdByName() -> [String: String]? { // fonction pour trouver l'id d'une ville a partir de son nom
    // dans le fichier cities list
    struct City: Codable {
        let id: Int
        let name: String
    }
    do {
        if let jsonFile = Bundle.main.url(forResource: "current.city.list.min", withExtension: "json") {
            // on va chercher dans le dossier ressources du playground
            let content = try Data(contentsOf: jsonFile)
            let  cities = try JSONDecoder().decode([City].self, from: content)
            var dictionary = [String: String]();
            for (city) in cities {
                dictionary[city.name] = String(city.id)
            }
            return dictionary;
        } else {
            print("file not found, check resources folder")
            return nil;
        }
    } catch {
        print(error.localizedDescription)
    }
    return nil;
}

func getForecastById(cityId : String){
    let query: [String: String] = [
        "id": cityId,
        "APPID": APIKEY
    ]
    
    let url = URL(string : forecastUrl)!.withQueries(query)!
    
    let task = URLSession.shared.dataTask(with: url) { (data,
        
        response, error) in
        
        let decoder = JSONDecoder()
        
        if let error = error {
            print(error.localizedDescription)
        }
        if let data = data { // le resultat du call
            
            let forecast = try! decoder.decode(Forecast.self,from: data)
            print(response)
            print(forecast)
            
            
        }
    }
    task.resume()
}

//************//
// execution //
//**********//
getForecastById(cityId : "524901")
getWeatherByName(city: "Leeds")
getWeatherById(cityId: "524901")// moscow by ID
if let citiesList = findCityIdByName(){
    if let cityId=findCityId(cityName: "London", cityDic: citiesList){ // recherche de l'id d'une ville par son nom
        getWeatherById(cityId: cityId)
    }
    
}

