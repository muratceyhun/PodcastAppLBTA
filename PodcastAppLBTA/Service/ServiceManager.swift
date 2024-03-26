//
//  ServiceManager.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 14.03.2024.
//

import UIKit

class ServiceManager {
    
    static let shared = ServiceManager()
    
    func fetchPodcasts(searchText: String, completion: @escaping ((Podcast?, Error?) -> ())) {
        
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&entity=podcast"

        guard let url = URL(string: urlString) else {return}
        
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
}
