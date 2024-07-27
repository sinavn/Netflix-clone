//
//  APICaller.swift
//  Netflix clone
//
//  Created by Sina Vosough Nia on 4/25/1403 AP.
//

import Foundation

struct Constants {
    static let apiKey = "0f04e0e2babb9c8e7c6dcc9c4256595e"
    static let baseURL = "https://api.themoviedb.org/3/"
}
class APICaller {
    static let shared = APICaller()
    
    enum networkError : Error {
        case invalidURL
        case invalidResponse
        case invalidData
        case invalidQuery
        case serverError(statusCode:Int)
    }
    enum apiURL : String {
        case TrendingMovies = "trending/movie/day?api_key="
        case TrendingTVs = "trending/tv/day?api_key="
        case UpcomingMovies = "movie/upcoming?api_key="
        case PopularMovies = "movie/popular?api_key="
        case TopRatedMovies = "movie/top_rated?api_key="
        case DiscoverMovies = "discover/movie?api_key="
    }
    func getTrendingMovies (get rawURL : apiURL) async throws -> [Movie] {
        guard let url = URL(string: "\(Constants.baseURL)\(rawURL.rawValue)\(Constants.apiKey)") else {
            throw networkError.invalidURL
        }
        
        do{
            let (data,response) = try await URLSession.shared.data(from: url)

            if let response = response as? HTTPURLResponse {
                if response.statusCode < 300 && response.statusCode >= 200 {
                    let result = try JSONDecoder().decode(MoviesModel.self, from: data)
                    return result.results
                }else{
                    throw networkError.serverError(statusCode: response.statusCode)
                }
            }else {
                throw networkError.invalidResponse
            }
        }catch{
            print("error fetching data (API caller ")
            throw error
        }

    }
    
    func search (for queryItem:String) async throws -> [Movie] {
        guard let allowedqueryItem = queryItem.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {throw networkError.invalidQuery}
        guard let url = URL(string: "\(Constants.baseURL)search/movie?api_key=\(Constants.apiKey)&query=\(allowedqueryItem)") else {
            throw networkError.invalidURL
        }
        do {
            let (data,response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else{throw networkError.invalidResponse}
            if response.statusCode >= 200 && response.statusCode < 300 {
                let result = try JSONDecoder().decode(MoviesModel.self, from: data)
                return result.results
            }else{
                throw networkError.serverError(statusCode: response.statusCode)
            }
        } catch  {
            print("error fetching data (search API call")
            throw error
        }
    }
}
