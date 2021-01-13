//
//  TableViewCell.swift
//  MusicApp
//
//  Created by Сергей Иванов on 06.01.2021.
//

import UIKit
import SDWebImage

protocol TrackCell {
    var artistName: String { get }
    var collectionName: String? { get }
    var trackName: String { get }
    var imageUrl: String? { get }
}

class TableViewCell: UITableViewCell {
    
    static let reuseId = "TrackCell"

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    
    var track: Track?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()

        trackImage.image = nil
    }

    func set(viewModel: Track) {
        self.track = viewModel
        
        trackName.text = viewModel.trackName
        artistName.text = viewModel.artistName
        collectionName.text = viewModel.collectionName
        
        if let url = URL(string: viewModel.imageUrl ?? "") {
            trackImage.sd_setImage(with: url, completed: nil)
        } else {
            trackImage.image = UIImage(systemName: "photo")
            trackImage.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        
        let userDefaults = UserDefaults.standard
        
        do {
            let response = try userDefaults.getObject(forKey: "tracks", castTo: SearchResponse.self)
            self.addButton.isHidden = response.results.firstIndex(where: {
                $0.trackName == self.trackName.text && $0.artistName == self.artistName.text
            }) != nil
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func onTappedAddButton(_ sender: Any) {
        guard let currentTrack = self.track else { return }
        
        self.addButton.isHidden = true
        
        var addedTracks = [Track]()
        
        let userDefaults = UserDefaults.standard
        
        do {
            let response = try userDefaults.getObject(forKey: "tracks", castTo: SearchResponse.self)
            addedTracks.append(contentsOf: response.results)
        } catch {
            print(error.localizedDescription)
        }
        
        addedTracks.append(currentTrack)
        
        let searchResponse = SearchResponse(resultCount: addedTracks.count, results: addedTracks)
        
    
        do {
            try userDefaults.setObject(searchResponse, forKey: "tracks")
            print("The track has saved successfully")
        } catch {
            print(error.localizedDescription)
        }
    }
}
