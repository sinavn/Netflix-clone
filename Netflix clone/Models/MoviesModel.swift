//
//  MoviesModel.swift
//  Netflix clone
//
//  Created by Sina Vosough Nia on 4/25/1403 AP.
//

import Foundation


struct MoviesModel : Codable  {
    let results: [Movie]
    
}

struct Movie : Codable {
    let backdropPath: String?
    let id: Int
    let originalTitle, originalName /*TV series*/ , overview, posterPath : String?
    let mediaType: MediaType?
    let adult: Bool?
    let title, originalLanguage: String?
    let genreIDS: [Int]
    let popularity: Double?
    let releaseDate: String?
    let firstAirDate: String?/*TV series*/
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case originalTitle = "original_title"
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult, title
        case originalLanguage = "original_language"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        
    }
}

enum MediaType: String , Codable  {
    case movie
    case tv
}
