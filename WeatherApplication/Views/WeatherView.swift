//
//  ContentView.swift
//  WeatherApplication
//
//  Created by Rachana  on 25/05/23.
//
import Foundation
import SwiftUI

//MARK: - Grid View Tile UI
struct WeatherTile: View, Identifiable {
    let id = UUID()
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)//Heading Text
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white)//Value Text
        }
    }
}

//MARK: - Content View
struct ContentView: View {
    
    @ObservedObject var viewModel = GetWeatherViewModel() //Instance of viewmodel
    @State var WeatherResponse:WeatherModel?//Instance of model of weather response
    @State private var searchString = String()//String passed to textfield
    @State private var isKeyboardVisible = false // Used for managing keyboard
    @State private var focusedFieldID: Int?// Used for focusing textfield
    @State private var locationManager:LocationManager?//Instance of location manager
    @State private var locationUpdateReceived = false
    
    
    //MARK: - Method to avoid pushing textfield when keyboard is opened.
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            isKeyboardVisible = true
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
            isKeyboardVisible = false
        }
    }
    
    //MARK: -  Method to focus the Textfield
    private func scrollToField(_ id: Int) {
        withAnimation {
            focusedFieldID = id
        }
    }
    
    // MARK: - Grid View Tile styling parameters
    let tileSpacing: CGFloat = 16
    let tileWidth: CGFloat = (UIScreen.main.bounds.width * 0.38)
    let tileHeight: CGFloat = (UIScreen.main.bounds.height * 0.12)
    
    var body: some View {
        
        ZStack {
            Image("Sky")
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .padding()
            ///Background image
            
            VStack{
                TextField("Enter City or State", text: $searchString)
                    .textFieldStyle(SearchTextFieldStyle())///Search Field
                
                Button("Find Weather Details"){
                    viewModel.getWeather(for: searchString) { (weather) in
                        self.WeatherResponse = weather
                        UserDefaults.standard.setValue(searchString, forKey: "PreviousCity")
                        UserDefaults.standard.synchronize()
                    }
                }
                .buttonStyle(PrimaryButtonStyle())//Button To Find the weather Details
                
                if let weatherData = self.WeatherResponse {
                    ///Image from remote url and City name displayed horizontally
                    
                    HStack{
                        RemoteImageView(url:(URL(string:"https://openweathermap.org/img/wn/\(self.WeatherResponse?.weather?[0].icon ?? "")@2x.png") ?? URL(string: "https://openweathermap.org/img/wn/10d@2x.png"))!,
                                        placeholder: {
                            Image("placeholder").frame(width: 20)},
                                        image: {
                            $0
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                            .frame(width: 40, height: 40)})
                        Text("\(self.WeatherResponse?.name ?? "")")
                            .modifier(MediumTextStyle())
                    }
                    
                    ///Temperature and weather description text
                    
                    Text("\(String(format: "%.2f", (roundTemperature(convertToFahrenheitFromKelvin(kelvin: self.WeatherResponse?.main?.temp ?? 0.0)))))")
                        .modifier(SemiBoldTextStyle())
                    Text("\(self.WeatherResponse?.weather?[0].description ?? "")")
                        .modifier(MediumTextStyle())
                    
                    HStack{
                        Text("H: \(String(format: "%.2f",self.WeatherResponse?.coord?.lon ?? 0.0))")
                            .modifier(MediumTextStyle())
                        
                        Text("L :\(String(format: "%.2f",self.WeatherResponse?.coord?.lat ?? 0.0))")
                            .modifier(MediumTextStyle())
                    }
                    
                    ///Grid which has weather details
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: tileWidth)),
                        GridItem(.adaptive(minimum: tileWidth))
                    ], spacing: tileSpacing) {
                        ForEach([
                            WeatherTile(title: "Temperature", value: String(format: "%.1f F", convertToFahrenheitFromKelvin(kelvin: (weatherData.main?.temp) ?? 0.0))),
                            WeatherTile(title: "Humidity", value: "\(weatherData.main?.humidity ?? 0)%"),
                            WeatherTile(title: "Wind", value: "\(weatherData.wind?.speed ?? 0.0) m/s"),
                            WeatherTile(title: "Description", value: weatherData.weather?.first?.description ?? ""),
                            WeatherTile(title: "Visibility", value: "\(String(weatherData.visibility ?? 0)) miles"),
                            WeatherTile(title: "Pressure", value: "\(String(weatherData.main?.pressure ?? 0)) inHg")
                        ]) { tile in
                            tile
                                .frame(width: tileWidth, height: tileHeight)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                        }
                    }
                } else {
                    Text("No City found")
                        .foregroundColor(.red)
                }
                Spacer()
                
            }.padding()
                .onAppear {
                    observeKeyboard()
                }
        }
        .animation(.default)
        .background(Color.clear.opacity(0.3))
        .onAppear {
            /// Initialising Location Manager to access User's Location.
            locationManager = LocationManager()
            locationManager?.locationUpdateReceived = { city in
                DispatchQueue.main.async {
                    viewModel.getWeather(for: city) { (weather) in
                        searchString = city
                        self.WeatherResponse = weather
                        print(weather as Any)
                    }
                }
            }
            
            if locationManager?.checkLocationAuthorization() == true {
                locationManager?.requestLocation()
            } else {
                /// Checking if User entered any city previously.
                if let city = UserDefaults.standard.value(forKey: "PreviousCity") as? String {
                    searchString = city
                    viewModel.getWeather(for: city) { (weather) in
                        self.WeatherResponse = weather
                        
                    }
                }
            }
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
    }
}


