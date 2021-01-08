//
//  TrackView.swift
//  MusicApp
//
//  Created by Сергей Иванов on 07.01.2021.
//

import UIKit
import SDWebImage
import AVKit


protocol SwitchTrackDelegate: class {
    func playNextTrack() -> Track?
    func playPreviousTrack() -> Track?
}

class TrackView: UIView {
    
    @IBOutlet weak var chevron: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackAuthor: UILabel!
    @IBOutlet weak var soundSlider: UISlider!
    
    weak var delegate: SwitchTrackDelegate?
    
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
        image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        guard let  previewUrl = URL(string: viewModel.previewUrl) else {
            return
        }
        let playerItem = AVPlayerItem(url: previewUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    // MARK: - Animation
    func enlargeTrackIcon() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.image.transform = .identity
        }, completion: nil)
    }
    
    func reduceTrackIcon() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
    }

    // MARK: - @IBAction
    
    @IBAction func chevronTapped(_ sender: Any) {
       self.removeFromSuperview()
    }
    
    @IBAction func dragTimeSlider(_ sender: Any) {
    }
    @IBAction func playpauseTapped(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            enlargeTrackIcon()
        } else {
            player.pause()
            reduceTrackIcon()
        }
    }
    @IBAction func nextTrackTapped(_ sender: Any) {
        guard let nextTrack = delegate?.playNextTrack() else { return }
        set(viewModel: nextTrack)
    }
    @IBAction func prevTrackTapped(_ sender: Any) {
        guard let prevTrack = delegate?.playPreviousTrack() else { return }
        set(viewModel: prevTrack)
    }
    @IBAction func soundSliderDrag(_ sender: Any) {
    }
}
