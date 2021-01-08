//
//  CMTimeExtension.swift
//  MusicApp
//
//  Created by Сергей Иванов on 08.01.2021.
//

import Foundation
import AVKit

extension CMTime {
    func covertToCustomTimeString() -> String  {
        guard !CMTimeGetSeconds(self).isNaN else { return ""}
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        return String(format: "%02d:%02d", seconds, minutes)
    }
}
