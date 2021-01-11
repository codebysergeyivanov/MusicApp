//
//  TrackView.swift
//  MusicApp
//
//  Created by Сергей Иванов on 07.01.2021.
//

import UIKit
import SDWebImage
import AVKit

protocol TrackViewDelegate: class {
    func maxSizeTrackView(viewModel: Track?) -> Void
    func minSizeTrackView() -> Void
}


protocol SwitchTrackDelegate: class {
    func playNextTrack() -> Track?
    func playPreviousTrack() -> Track?
}

class TrackView: UIView {
    
    
    @IBOutlet weak var miniPlayer: UIView!
    @IBOutlet weak var miniTrackIcon: UIImageView!
    @IBOutlet weak var miniTrackName: UILabel!
    @IBOutlet weak var miniTrackAuthor: UILabel!
    
    
    @IBOutlet weak var maxPlayer: UIStackView!
    @IBOutlet weak var chevron: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackAuthor: UILabel!
    @IBOutlet weak var soundSlider: UISlider!
    
    weak var delegate: SwitchTrackDelegate?
    weak var trackViewDelegate: TrackViewDelegate?
    
    var player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer()
    }
    
    
    func set(viewModel: Track) {
        miniTrackName.text = viewModel.trackName
        miniTrackAuthor.text = viewModel.artistName
        
        trackName.text = viewModel.trackName
        trackAuthor.text = viewModel.artistName
        
        
        let urlString = viewModel.imageUrl?.replacingOccurrences(of: "100x100", with: "600x600")
        if let url = URL(string: urlString ?? "") {
            image.sd_setImage(with: url, completed: nil)
            miniTrackIcon.sd_setImage(with: url, completed: nil)
        } else {
            image.image = UIImage(systemName: "photo")
            image.tintColor = #colorLiteral(red: 0.9136453271, green: 0.9137768149, blue: 0.9136165977, alpha: 1)
            miniTrackIcon.image = UIImage(systemName: "photo")
            miniTrackIcon.tintColor = #colorLiteral(red: 0.9136453271, green: 0.9137768149, blue: 0.9136165977, alpha: 1)
        }
        image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        guard let  previewUrl = URL(string: viewModel.previewUrl) else {
            return
        }
        let playerItem = AVPlayerItem(url: previewUrl)
        player.replaceCurrentItem(with: playerItem)
        monitorStartTime()
        player.play()
    }
    
    // MARK: - UI Gesture
    
    func addGestureRecognizer() {
        miniPlayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOnTapMiniPlayer)))
        
        miniPlayer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleOnPanMiniPlayer)))
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleOnPanMaxPlayer)))
    }
    
    
    // MARK: - UI Gesure handler
    
    @objc func handleOnTapMiniPlayer() {
        trackViewDelegate?.maxSizeTrackView(viewModel: nil)
    }
    
    @objc func handleOnPanMiniPlayer(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handleOnPanChanged(gesture: gesture)
        case .ended:
            handleOnPanEnded(gesture: gesture)
        @unknown default:
            print("default")
        }
    }
      
    func handleOnPanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let newAlhfa = 1 + translation.y / 200
        miniPlayer.alpha = newAlhfa < 0 ? 0 : newAlhfa
        maxPlayer.alpha = -newAlhfa
        
    }
    
    func handleOnPanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
            self.transform = .identity
            if translation.y < -200 && velocity.y < -500 {
                self.trackViewDelegate?.maxSizeTrackView(viewModel: nil)
            } else {
                self.miniPlayer.alpha = 1
                self.maxPlayer.alpha = 0
            }
        }, completion: nil)
    }
    
    @objc func handleOnPanMaxPlayer(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handleOnPanMaxPlayerChanged(gesture: gesture)
        case .ended:
             handleOnPanMaxPlayerEnded(gesture: gesture)
        @unknown default:
            print("default")
        }
    }
    
    func handleOnPanMaxPlayerChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let newAlhfa = 1 - translation.y / 200
        print(newAlhfa)
        miniPlayer.alpha = 1 - newAlhfa
        maxPlayer.alpha = newAlhfa < 0 ? 0 : newAlhfa
        
    }
    
    func handleOnPanMaxPlayerEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.transform = .identity
            
            if translation.y > 50 && velocity.y > 250 {
                self.trackViewDelegate?.minSizeTrackView()
            } else {
                self.miniPlayer.alpha = 0
                self.maxPlayer.alpha = 1
            }
        }, completion: nil)
    }
    
    // MARK: - Time
    
    func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main, using: {
            [weak self] in
            self?.enlargeTrackIcon()
        })
        setCurrentTime()
    }
    
    func setCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: {[weak self] time in
            self?.currentTime.text = time.covertToCustomTimeString()
            
            let duration = ((self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)) - time).covertToCustomTimeString()
            self?.trackDuration.text = "-\(duration)"
            
            self?.updateTimeSlider()
        })
    }
    
    func updateTimeSlider() {
        let percent = CMTimeGetSeconds(self.player.currentTime()) / CMTimeGetSeconds(self.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        self.timeSlider.value = Float(percent)
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
        trackViewDelegate?.minSizeTrackView()
    }
    
    @IBAction func dragTimeSlider(_ sender: Any) {
        let precent = self.timeSlider.value
        let duration = CMTimeGetSeconds(self.player.currentItem?.duration  ?? CMTimeMake(value: 1, timescale: 1))
        let seconds = Float64(precent) * duration
        let seekSeconds = CMTimeMakeWithSeconds(seconds, preferredTimescale: 1)
        player.currentItem?.seek(to: seekSeconds, completionHandler: nil)
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
        player.volume = soundSlider.value
    }
}

