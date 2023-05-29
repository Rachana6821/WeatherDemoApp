//
//  WeatherViewController.swift
//  WeatherApplication
//
//  Created by Rachana  on 28/05/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var mainTemperatureLabel: UILabel!
    @IBOutlet weak var skyLabel: UILabel!
    @IBOutlet weak var highLowlabel: UILabel!
    @IBOutlet var cityNotFoundLabel: UILabel!
    
    /// cards
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var cardsBgView: UIView!
    
    /// view model
    var viewModel = GetWeatherViewModel()
    
    var locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    func setupUI() {
        textField.addLeftPadding(15)
        textField.delegate = self
        cardsBgView.isHidden = true
        
        cityNotFoundLabel.frame = CGRect(x: 0, y: cardsBgView.frame.origin.y + (UIDevice.current.hasNotch ? 100 : 40), width: UIScreen.main.bounds.width, height: 20)
        view.addSubview(cityNotFoundLabel)
        cityNotFoundLabel.isHidden = true
        
        
        /// Checking if User entered any city previously.
        if let city = UserDefaults.standard.value(forKey: "PreviousCity") as? String {
            getWeatherDetails(city: city)
        }else{
            if locationManager.checkLocationAuthorization() == true{
                locationManager.requestLocation()
            }
            
        }
        
        
        locationManager.locationUpdateReceived = { city in
            self.getWeatherDetails(city: city)
        }
        
    }
    
    func updateUI() {
        cardsBgView.isHidden = false
        cityNotFoundLabel.isHidden = true
        let data = viewModel.weatherData
        textField.text = data?.name
        cityLabel.text = data?.name
        mainTemperatureLabel.text = ("\(String(format: "%.2f", (roundTemperature(convertToFahrenheitFromKelvin(kelvin: data?.main?.temp ?? 0.0)))))")
        skyLabel.text = data?.weather?[0].description
        highLowlabel.text = "H: \(String(format: "%.2f", data?.coord?.lon ?? 0.0))  L :\(String(format: "%.2f",data?.coord?.lat ?? 0.0))"
        
        /// cards
        temperatureLabel.text = String(format: "%.1f F", convertToFahrenheitFromKelvin(kelvin: (data?.main?.temp) ?? 0.0))
        humidityLabel.text = "\(data?.main?.humidity ?? 0)%"
        windLabel.text = "\(data?.wind?.speed ?? 0.0) m/s"
        descriptionLabel.text = data?.weather?.first?.description ?? ""
        visibilityLabel.text = "\(String(data?.visibility ?? 0)) miles"
        pressureLabel.text = "\(String(data?.main?.pressure ?? 0)) inHg"
    }
    
    func getWeatherDetails(city: String) {
        viewModel.getWeather(for: city) { (weather) in
            DispatchQueue.main.async { [self] in
                if weather == nil {
                    cityNotFoundLabel.isHidden = false
                    cardsBgView.isHidden = true
                }else{
                    updateUI()
                }
            }
        }
    }
    
    //  MARK: - Button Actions
    @IBAction func findWeatherDetailsButtonAction(_ sender: UIButton) {
        if let city = textField.text, city != "" {
            UserDefaults.standard.setValue(city, forKey: "PreviousCity")
            UserDefaults.standard.synchronize()
            getWeatherDetails(city: city)
        }
    }
    
}


extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
