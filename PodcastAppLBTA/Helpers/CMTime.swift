//
//  CMTime.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 24.03.2024.
//

import AVKit


extension CMTime {
    
    func toDisplayString() -> String {
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
    }
}



