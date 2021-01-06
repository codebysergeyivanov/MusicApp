//
//  SearchModels.swift
//  MusicApp
//
//  Created by Сергей Иванов on 06.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Search
{
  // MARK: Use cases
  
  enum Something
  {
    struct Request
    {
        enum RequestType {
            case getTracks(searchText: String)
        }
    }
    struct Response
    {
        enum ResponseType {
            case normalizeTracks(searchResponse: SearchResponse?)
        }
    }
    struct ViewModel
    {
        enum ViewModelType {
            case presentTracks(tracks: [Track])
        }
    }
  }
}

struct SearchResponse: Codable {
    var resultCount: Int
    let results: [Track]
}

struct Track: Codable, TrackCell {
    var artistName: String
    var collectionName: String?
    var trackName: String
    var imageUrl: String?
    var previewUrl: String
    
    enum CodingKeys: String, CodingKey {
        case artistName
        case collectionName
        case trackName
        case previewUrl
        case imageUrl = "artworkUrl100"
    }
}

