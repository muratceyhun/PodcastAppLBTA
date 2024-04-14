//
//  Podcast.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 14.03.2024.
//

import Foundation


struct Podcast: Codable {
    
    let results: [PodcastResult]

}

class PodcastResult: NSObject, Codable, NSCoding {
    

    func encode(with coder: NSCoder) {
        
        coder.encode(artistName ?? "", forKey: "artistNameKey")
        coder.encode(collectionName ?? "", forKey: "collectionNameKey")
        coder.encode(artworkUrl600 ?? "", forKey: "artworkKey")
        coder.encode(feedUrl ?? "", forKey: "feedUrlKey")

    }
    
    required init?(coder: NSCoder) {
        
        self.collectionName = coder.decodeObject(forKey: "collectionNameKey") as? String
        self.artistName = coder.decodeObject(forKey: "artistNameKey") as? String
        self.artworkUrl600 = coder.decodeObject(forKey: "artworkKey") as? String
        self.feedUrl = coder.decodeObject(forKey: "feedUrlKey") as? String

    }
        
    
    let artistName: String?
    let collectionName: String?
    let artworkUrl600: String?
    var trackId: Int?
    var collectionId: Int?
    var trackCount: Int?
    var artistId: Int?
    var feedUrl: String?
    
}


