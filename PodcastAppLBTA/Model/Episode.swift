//
//  Episode.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 18.03.2024.
//

import Foundation
import FeedKit


struct Episode: Codable {
    
    let title: String?
    let pubDate: Date?
    let artistName: String?
    let description: String?
    let imageUrl: String?
    let url: String?
    
    init(episode: RSSFeedItem) {
        self.title = episode.title ?? ""
        self.pubDate = episode.pubDate ?? Date()
        self.artistName = episode.iTunes?.iTunesAuthor ?? ""
        self.description = episode.description ?? ""
        self.imageUrl = episode.iTunes?.iTunesImage?.attributes?.href ?? ""
        self.url = episode.enclosure?.attributes?.url ?? ""

    }
}










