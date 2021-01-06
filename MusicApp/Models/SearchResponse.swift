//
//  SearchResponse.swift
//  MusicApp
//
//  Created by Сергей Иванов on 05.01.2021.
//

import Foundation


struct SearchResponse: Decodable {
    var resultCount: Int
    let results: [Track]
}

struct Track: Decodable {
    var artistName: String
    var collectionName: String?
    var trackName: String
    var artworkUrl100: String?
}
