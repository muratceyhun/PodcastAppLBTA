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
        coder.encode(trackId ?? "", forKey: "trackIDKey")
        coder.encode(collectionId ?? "", forKey: "collectionIdKey")
        coder.encode(trackCount ?? "", forKey: "trackCountKey")
        coder.encode(artistId ?? "", forKey: "artistIdKey")
        coder.encode(feedUrl ?? "", forKey: "feedUrlKey")


    }
    
    required init?(coder: NSCoder) {
        
        self.collectionName = coder.decodeObject(forKey: "collectionNameKey") as? String
        self.artistName = coder.decodeObject(forKey: "artistNameKey") as? String
        self.artworkUrl600 = coder.decodeObject(forKey: "artworkKey") as? String
        self.trackId = coder.decodeObject(forKey: "trackIDKey") as? Int
        self.collectionId = coder.decodeObject(forKey: "collectionIdKey") as? Int
        self.trackCount = coder.decodeObject(forKey: "trackCountKey") as? Int
        self.artistId = coder.decodeObject(forKey: "artistIdKey") as? Int
        self.feedUrl = coder.decodeObject(forKey: "feedUrlKey") as? String


    }
        
    
    let artistName: String?
    let collectionName: String?
    let artworkUrl600: String?
    let trackId: Int?
    let collectionId: Int?
    let trackCount: Int?
    let artistId: Int?
    let feedUrl: String?
    
}


