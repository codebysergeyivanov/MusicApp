//
//  TrackView.swift
//  MusicApp
//
//  Created by Сергей Иванов on 07.01.2021.
//

import UIKit
import SDWebImage
import AVKit

class TrackView: UIView {
    
    @IBOutlet weak var chevron: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackAuthor: UILabel!
    @IBOutlet weak var soundSlider: UISlider!
    
    var player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func set(viewModel: Track) {
        trackName.text = viewModel.trackName
        trackAuthor.text = viewModel.artistName
        
        
        let urlString = viewModel.imageUrl?.replacingOccurrences(of: "100x100", with: "600x600")
        if let url = URL(string: urlString ?? "") {
            image.sd_setImage(with: url, completed: nil)
        } else {
            image.image = UIImage(systemName: "photo")
            image.tintColor = #colorLiteral(red: 0.9136453271, green: 0.9137768149, blue: 0.9136165977, alpha: 1)
        }
        
        guard let  previewUrl = URL(string: viewModel.previewUrl) else {
            return
        }
        let playerItem = AVPlayerItem(url: previewUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

    
    @IBAction func chevronTapped(_ sender: Any) {
       self.removeFromSuperview()
    }
    
    @IBAction func dragTimeSlider(_ sender: Any) {
    }
    @IBAction func playpauseTapped(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
        } else {
            player.pause()
        }
    }
    @IBAction func nextTrackTapped(_ sender: Any) {
    }
    @IBAction func prevTrackTapped(_ sender: Any) {
    }
    @IBAction func soundSliderDrag(_ sender: Any) {
    }
}
