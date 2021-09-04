//
//  NetworkCallsProtocol.swift
//  RainOrShine
//
//  Created by Andy Lim on 8/31/21.
//  Copyright © 2021 Andy Lim. All rights reserved.
//

protocol NetworkManagerProtocol {
    func fetchCurrentWeather(city: String, completion: @escaping (WeatherModel) -> ())
    func fetchCurrentLocationWeather(lat: String, lon: String, completion: @escaping (WeatherModel) -> ())
    func fetchNextFiveWeatherForecast(city: String, state: String, completion: @escaping ([ForecastTemperature]) -> ())
}
