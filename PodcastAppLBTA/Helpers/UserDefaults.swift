//
//  UserDefaults.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 6.04.2024.
//

import Foundation


extension UserDefaults {
    
    static let favKey = "favKey"
    
    func savedPodcasts() -> [PodcastResult] {
        
        guard let savedPodcastData = UserDefaults.standard.data(forKey: UserDefaults.favKey) else {return []}
        
        do {
            guard let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastData) as? [PodcastResult] else {return [] }
            return savedPodcasts
        } catch let err {
            print("Failed to save podcats", err)
            return []
        }
        
        
        
    }
    

    
}
