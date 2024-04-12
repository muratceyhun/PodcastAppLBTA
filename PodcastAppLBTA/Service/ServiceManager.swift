//
//  ServiceManager.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 14.03.2024.
//

import UIKit
import FeedKit

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
    
    
    
    func fetchEpisodes(podcast: PodcastResult, completion: @escaping ([Episode]?, Error?) -> ()) {
        
                    
        guard let feedUrl = podcast.feedUrl else {return}
            print(feedUrl)
            
            guard let url = URL(string: feedUrl) else {return}
            
            
            DispatchQueue.global(qos: .background).async {
                let parser = FeedParser(URL: url)
                
                parser.parseAsync { result in
                    
                    
                    switch result {
                    case .success(let feed):
                        
                        switch feed {
                        case let .rss(feed):
                            var episodes = [Episode]()
                            
                            feed.items?.forEach({ episode in
                                let episode = Episode(episode: episode)
                                episodes.append(episode)
                            })
                            completion(episodes, nil)
                            
                            break
                        case .atom(_):
                            break
                        case .json(_):
                            break
                        }
                        
                        
                        
                    case .failure(let err):
                        print(err)
                        completion(nil, err)
                    }
                }
            }
    }
}
