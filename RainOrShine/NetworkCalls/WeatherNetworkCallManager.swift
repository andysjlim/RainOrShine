//
//  WeatherNetworkCallManager.swift
//  RainOrShine
//
//  Created by Andy Lim on 8/31/21.
//  Copyright © 2021 Andy Lim. All rights reserved.
//

import Foundation


class WeatherNetworkManager : NetworkManagerProtocol {
    static let shared = WeatherNetworkManager()
    
    var lat = "60.99"
    var long = "30.0"
    
    func setLatitude(_ latitude: String)
    {
        lat = latitude
    }
    
    func setLatitude(_ latitude: Double)
    {
        setLatitude(String(latitude))
    }
    
    func setLongitude(_ longitude: String)
    {
        long = longitude
    }
    
    func setLongitude(_ longitude: Double)
    {
        setLongitude(String(longitude))
    }
    
    
    func fetchNextFiveWeatherForecast(city: String, state: String, completion: @escaping ([ForecastTemperature]) -> ()) {
        let formattedCity = city.replacingOccurrences(of: " ", with: "+")
        let API_URL = "http://api.openweathermap.org/data/2.5/forecast?q=\(formattedCity),\(state)&appid=\(NetworkProperties.API_KEY)"
        
        var currentDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var secondDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var thirdDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var fourthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var fifthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var sixthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        
    
        guard let url = URL(string: API_URL) else {
                 fatalError()
             }
             let urlRequest = URLRequest(url: url)
             URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
                guard self != nil else { return }
                 guard let data = data else { return }
                 do {
                    
                    let forecastWeather = try JSONDecoder().decode(ForecastModel.self, from: data)
                        
                    var forecastmodelArray : [ForecastTemperature] = []
                    var fetchedData : [WeatherInfo] = [] //Just for loop completion
                    
                    var currentDayForecast : [WeatherInfo] = []
                    var secondDayForecast : [WeatherInfo] = []
                    var thirddayDayForecast : [WeatherInfo] = []
                    var fourthDayDayForecast : [WeatherInfo] = []
                    var fifthDayForecast : [WeatherInfo] = []
                    var sixthDayForecast : [WeatherInfo] = []
                    
                    print("Total data:", forecastWeather.list.count)
                    var totalData = forecastWeather.list.count //Should be 40 all the time
                    
                    for day in 0...forecastWeather.list.count - 1 {
                            
                        
                        let listIndex = day//(8 * day) - 1
                        let mainTemp = forecastWeather.list[listIndex].main.temp
                        let minTemp = forecastWeather.list[listIndex].main.temp_min
                        let maxTemp = forecastWeather.list[listIndex].main.temp_max
                        let descriptionTemp = forecastWeather.list[listIndex].weather[0].description
                        let icon = forecastWeather.list[listIndex].weather[0].icon
                        let time = forecastWeather.list[listIndex].dt_txt!
                    
                        let dateFormatter = DateFormatter()
                        dateFormatter.calendar = Calendar(identifier: .gregorian)
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let date = dateFormatter.date(from: forecastWeather.list[listIndex].dt_txt!)
                        
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.weekday], from: date!)
                        let weekdaycomponent = components.weekday! - 1  //Just the integer value from 0 to 6
                        
                        let f = DateFormatter()
                        let weekday = f.weekdaySymbols[weekdaycomponent] // 0 Sunday 6 - Saturday //This is where we are getting the string val (Mon/Tue/Wed...)
                            
                        let currentDayComponent = calendar.dateComponents([.weekday], from: Date())
                        let currentWeekDay = currentDayComponent.weekday! - 1
                        let currentweekdaysymbol = f.weekdaySymbols[currentWeekDay]
                        
                        if weekdaycomponent == currentWeekDay - 1 {
                            totalData = totalData - 1
                        }
                        
                        
                        if weekdaycomponent == currentWeekDay {
                            let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                            currentDayForecast.append(info)
                            currentDayTemp = ForecastTemperature(weekDay: currentweekdaysymbol, hourlyForecast: currentDayForecast)
                            print("1")
                            fetchedData.append(info)
                        }else if weekdaycomponent == currentWeekDay+1 {
                            let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                            secondDayForecast.append(info)
                            secondDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: secondDayForecast)
                            print("2")
                            fetchedData.append(info)
                        }else if weekdaycomponent == currentWeekDay+2 {
                            let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                            thirddayDayForecast.append(info)
                            print("3")
                            thirdDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: thirddayDayForecast)
                            fetchedData.append(info)
                        }else if weekdaycomponent == currentWeekDay+3 {
                            let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                            fourthDayDayForecast.append(info)
                            print("4")
                            fourthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: fourthDayDayForecast)
                            fetchedData.append(info)
                        }else if weekdaycomponent == currentWeekDay+4{
                            let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                            fifthDayForecast.append(info)
                            fifthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: fifthDayForecast)
                            fetchedData.append(info)
                            print("5")
                        }else if weekdaycomponent == currentWeekDay+5 {
                            let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                            sixthDayForecast.append(info)
                            sixthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: sixthDayForecast)
                            fetchedData.append(info)
                            print("6")
                        }

                        
                        if fetchedData.count == totalData {
                            
                            if currentDayTemp.hourlyForecast?.count ?? 0 > 0 {
                                forecastmodelArray.append(currentDayTemp)
                            }
                            
                            if secondDayTemp.hourlyForecast?.count ?? 0 > 0 {
                                forecastmodelArray.append(secondDayTemp)
                            }
                            
                            if thirdDayTemp.hourlyForecast?.count ?? 0 > 0 {
                                forecastmodelArray.append(thirdDayTemp)
                            }
                            
                            if fourthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                                forecastmodelArray.append(fourthDayTemp)
                            }
                            
                            if fifthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                                forecastmodelArray.append(fifthDayTemp)
                            }
                            
                            if sixthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                                forecastmodelArray.append(sixthDayTemp)
                            }
                            
//                            if seventhDayTemp.hourlyForecast?.count ?? 0 > 0{
//                                forecastmodelArray.append(seventhDayTemp)
//                            }
                            
                            if forecastmodelArray.count <= 6 {
                                completion(forecastmodelArray)
                            }
                            
                        }
                        
                     
                        
                    }
                 } catch {
                     print(error)
                 }
                     
        }.resume()
    }
    
    func fetchCurrentWeather(city: String, completion: @escaping (WeatherModel) -> ()) {
        
        let formattedCity = city.replacingOccurrences(of: " ", with: "+")
        let API_URL = "http://api.openweathermap.org/data/2.5/weather?q=\(formattedCity)&appid=\(NetworkProperties.API_KEY)"

        guard let url = URL(string: API_URL) else {
            fatalError()
        }
                     
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        guard let data = data else { return }

            do {
                let currentWeather = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(currentWeather)
            } catch {
                 print(error)
            }

        }.resume()
    }
    
    func fetchOneCallLocationWeather(completion: @escaping (OneCall) -> ()) {
        let API_URL = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely,alerts,daily&appid=\(NetworkProperties.API_KEY)"
        
        guard let url = URL(string: API_URL) else {
            fatalError()
        }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            do {
                let currentWeather = try JSONDecoder().decode(OneCall.self, from: data)
                completion(currentWeather)
            } catch {
                print(error)
            }
        }.resume()
    }
    
}
