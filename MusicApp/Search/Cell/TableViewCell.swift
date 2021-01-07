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

    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        trackImage.image = nil
    }

    func set(viewModel: TrackCell) {
        trackName.text = viewModel.trackName
        artistName.text = viewModel.artistName
        collectionName.text = viewModel.collectionName
        
        if let url = URL(string: viewModel.imageUrl ?? "") {
            trackImage.sd_setImage(with: url, completed: nil)
        } else {
            trackImage.image = UIImage(systemName: "photo")
            trackImage.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }

}
