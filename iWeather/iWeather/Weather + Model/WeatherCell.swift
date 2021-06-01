

import UIKit

class WeatherCell: UITableViewCell {
    
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // HexColour
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static let identifier = "WeatherCell"
    
    func configure (with model: Daily) {
        self.tempLabel.text = "\(Int(model.temp.day))°C"
        self.weatherIcon.image = UIImage(named: "partlysunny")
        self.dayLabel.text! = getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))
        
        if model.weather[0].description.contains("rain") {
            self.weatherIcon.image = UIImage(named: "rain")
        } else if  model.weather[0].description.contains("sunny") {
            self.weatherIcon.image = UIImage(named: "partlysunny")
        } else if model.weather[0].description.contains("cloud") {
            self.weatherIcon.image = UIImage(named: "clear")
        } else {
            self.weatherIcon.image = UIImage(named: "clear")
        }

        
    }
    
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputDate)
    }

}


