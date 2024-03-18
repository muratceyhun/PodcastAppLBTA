//
//  ServiceManager.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 14.03.2024.
//

import UIKit

class ServiceManager {
    
    static let shared = ServiceManager()
    
    func fetchPodcasts(url: String, completion: @escaping ((Podcast?, Error?) -> ())) {
        

        guard let url = URL(string: url) else {return}
        
                URLSession.shared.dataTask(with: url) { data, _, err in
                    
                    if let err = err {
                        print("Failed to fetch data", err)
                        completion(nil, err)
                        return
                    }
                    
                    guard let data = data else {return}
                    
                    
                    do {
                        
                        let podcasts = try JSONDecoder().decode(Podcast.self, from: data)
                        completion(podcasts, nil)
                    } catch let err {
                        print("Failed to decode", err)
                        completion(nil, err)
                    }
        
                    
                }.resume()
        
        
        
        
    }
    
    func fetchEpisodes(url: String, completionHandler: @escaping ((Episode?, Error?) -> ())) {
        
        guard let url = URL(string: url) else {return}
        
                URLSession.shared.dataTask(with: url) { data, _, err in
                    
                    if let err = err {
                        print("Failed to fetch episodes", err)
                        completionHandler(nil, err)
                        return
                    }
                    
                    guard let data = data else {return}
                    
                    
                    do {
                        let episodes = try JSONDecoder().decode(Episode.self, from: data)
                        completionHandler(episodes, nil)
                    } catch let err {
                        print("Failed to decode episode data", err)
                        completionHandler(nil, err)
                    }
                    
                }.resume()
        
    }
}
