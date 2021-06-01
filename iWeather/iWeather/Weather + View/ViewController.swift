

import UIKit
import CoreLocation

class ViewController: UIViewController{
    let locationManager = CLLocationManager()
    let currentWeatherDataModel = [CurrentWeatherData].self
    let hexColour = HexColourDelegate()
    var dayModels = [Daily]()
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var currentWeatherTemp: UILabel!
    @IBOutlet weak var currentWeatherDescription: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        table.dataSource = self
        table.delegate = self
        locationManager.delegate = self
        currentWeatherTemp.text = "30°"
        currentWeatherDescription.text = "Cloud"
        minTemp.text = "26°"
        minLabel.text = "Min"
        currentTemp.text = "30°"
        currentLabel.text = "Current"
        maxTemp.text = "40°"
        maxLabel.text = "Max"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

}

//MARK: - TableViewDelegate -
extension ViewController: UITableViewDelegate {

}


//MARK: - TableViewDataSource -

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dayModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as! WeatherCell
        cell.backgroundColor = UIColor.clear
        cell.configure(with: dayModels[indexPath.row])
        return cell
    }

}

//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        

        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("Latitude: \(lat), Longitude: \(lon)")
            
            // Current Weather
            let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather?q=asaba&appid=435993cb111961cf1411bdf830d30556&units=metric"
            
            URLSession.shared.dataTask(with: URL(string: currentWeatherURL)!, completionHandler: { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                var json: CurrentWeatherData?
                do {
                    json = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
                }
                catch {
                    print("error: \(error)")
                }
                guard let result = json else {
                    return
                }
                DispatchQueue.main.async {
                    self.currentWeatherTemp.text = "\(Int(result.main.temp))°C"
                    self.currentWeatherDescription.text = "\(result.weather[0].main)"
                    self.minTemp.text = "\(Int(result.main.temp_min))°C"
                    self.currentTemp.text = "\(Int(result.main.temp))°C"
                    self.maxTemp.text = "\(Int(result.main.temp_max))°C"
                    
                    if result.weather[0].description.contains("sunny") {
                        self.backgroundImage.image = UIImage(named: "sea_sunnypng")
//
                        self.view.backgroundColor = self.hexColour.hexStringToUIColor("47AB2F")
                        self.table.backgroundColor = self.hexColour.hexStringToUIColor( "47AB2F")
                        
                    } else if result.weather[0].description.contains("cloud") {
                        self.backgroundImage.image = UIImage(named: "sea_cloudy")
                        self.table.backgroundColor = self.hexColour.hexStringToUIColor("54717A")
                        self.view.backgroundColor = self.hexColour.hexStringToUIColor("54717A")
                    } else if result.weather[0].description.contains("rain") {
                        self.backgroundImage.image = UIImage(named: "sea_rainy")
                        self.table.backgroundColor = self.hexColour.hexStringToUIColor("57575D")
                        self.view.backgroundColor = self.hexColour.hexStringToUIColor("57575D")
                    } else {
                        self.backgroundImage.image = UIImage(named: "sea_sunnypng")
                    }
                }

            }).resume()
        }
        
        

        //One Call
        let daysURL = "https://api.openweathermap.org/data/2.5/onecall?lat=6.2006&lon=6.7338&appid=435993cb111961cf1411bdf830d30556&units=metric&exclude=hourly"
        URLSession.shared.dataTask(with: URL(string: daysURL)!, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                return
            }
            var dayJSON: DaysWeatherData?
            do {
                dayJSON = try JSONDecoder().decode(DaysWeatherData.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            guard let dayResult = dayJSON else {
                return
            }
            let dayEntries = dayResult.daily
            self.dayModels.append(contentsOf: dayEntries)
            
            DispatchQueue.main.async {
                self.table.reloadData()
            }

        }).resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
    
}
