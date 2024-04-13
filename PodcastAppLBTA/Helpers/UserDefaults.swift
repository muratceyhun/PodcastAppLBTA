//
//  UserDefaults.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 6.04.2024.
//

import Foundation
import FeedKit


extension UserDefaults {
    
    static let favKey = "favKey"
    static let downloadKey = "downloadKey"
    
    
    func downloadEpisode(episode: Episode) {
        
        do {
            var downloadedEpisodes = fetchDownloadedEpisodes()
//            downloadedEpisodes.append(episode)
            downloadedEpisodes.insert(episode, at: 0)
            let episodeData = try JSONEncoder().encode(downloadedEpisodes)
            UserDefaults.standard.set(episodeData, forKey: UserDefaults.downloadKey)
            
        } catch let err {
            
            print("Failed to turn the episode into data...", err)
            
        }
        
    }
    
    
    func deleteEpisode(episode: Episode) {
        
        let downloadedEpisodes = UserDefaults.standard.fetchDownloadedEpisodes()
        let updatedEpisodes = downloadedEpisodes.filter{$0.imageUrl != episode.imageUrl && $0.title != episode.title}
        do {
            let updatedEpisodesData = try JSONEncoder().encode(updatedEpisodes)
            UserDefaults.standard.set(updatedEpisodesData, forKey: UserDefaults.downloadKey)

        } catch let err {
            print("Failed to encode updated episodes", err)
        }
        
    }
    
    
    func fetchDownloadedEpisodes() -> [Episode] {
        
        guard let downloadedEpisodesData = UserDefaults.standard.data(forKey: UserDefaults.downloadKey) else {return []}
        
        do {
            
            let downloadedEpisodes = try JSONDecoder().decode([Episode].self, from: downloadedEpisodesData)
            return downloadedEpisodes
            
        } catch let err {
            print("Failed to decode downloaded episodes:", err)
            return []
        }
    }
    
    
    func fetchFavoritePodcasts() -> [PodcastResult] {
        
        guard let savedPodcastData = UserDefaults.standard.data(forKey: UserDefaults.favKey) else {return []}
        
        do {
            guard let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastData) as? [PodcastResult] else {return [] }
            return savedPodcasts
        } catch let err {
            print("Failed to save podcats", err)
            return []
        }
    }
    
    func deletePodcast(podcast: PodcastResult) {
        
        let favoritePodcasts = fetchFavoritePodcasts()

        let updatedPodcasts = favoritePodcasts.filter{$0.collectionId != podcast.collectionId}
        do {
            let updatedPodcastsData = try NSKeyedArchiver.archivedData(withRootObject: updatedPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(updatedPodcastsData, forKey: UserDefaults.favKey)
            print("Deleting selected podcast successfully.")
            
        } catch let err {
            print("Failed to get updatedData", err)
        }
    }
}
