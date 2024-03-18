//
//  Podcast.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 14.03.2024.
//

import Foundation


struct Podcast: Codable {
    
    let resultCount: Int
    let results: [PodcastResult]
}

struct PodcastResult: Codable {
    
    let artistName: String?
    let collectionName: String?
    let artworkUrl600: String?
    let trackId: Int?
    let collectionId: Int?
    let trackCount: Int?
    let artistId: Int?

}
