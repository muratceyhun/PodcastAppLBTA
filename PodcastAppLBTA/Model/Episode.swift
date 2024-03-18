//
//  Episode.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 18.03.2024.
//

import Foundation



struct Episode: Codable {
    
    let resultCount: Int
    let results: [EpisodeResult]
    
}


struct EpisodeResult: Codable {
    
    let trackName: String?
    let artworkUrl60: String?
    let trackId: Int?
    
}



