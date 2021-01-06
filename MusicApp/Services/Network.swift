//
//  NetworkService.swift
//  MusicApp
//
//  Created by Сергей Иванов on 05.01.2021.
//

import UIKit
import Alamofire

class Network {
    func fetchTracks(searchText: String, complition: @escaping (SearchResponse?) -> Void) {
        let url = "https://itunes.apple.com/search"
        let parametrs = ["term":"\(searchText)","media":"music","limit":"10"]
        AF.request(url,
                   method: .get,
                   parameters: parametrs,
                   encoder: URLEncodedFormParameterEncoder.default).responseData {
                    response in
                    if let error = response.error {
                        print(error)
                        complition(nil)
                    }
                    
                    guard let data = response.data else { return }
                    
                    let decoder = JSONDecoder()
                    do {
                        let objects = try decoder.decode(SearchResponse.self, from: data)
                        complition(objects)
                    } catch let jsonError {
                        print(jsonError)
                        complition(nil)
                    }
                   }
    }
}
