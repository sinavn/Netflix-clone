//
//  YtSearchResult.swift
//  Netflix clone
//
//  Created by Sina Vosough Nia on 5/7/1403 AP.
//

import Foundation

struct YtSearchResultModel: Codable {
   
    let items: [YoutubeItem]
}

struct YoutubeItem: Codable {
    let id: YoutubeItemId
}

struct YoutubeItemId: Codable {
    let videoId: String
    
  
}

