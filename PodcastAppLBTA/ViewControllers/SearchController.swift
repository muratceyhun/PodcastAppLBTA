//
//  SearchController.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 13.03.2024.
//

import UIKit
import SDWebImage
import FeedKit


class SearchController: BaseListController, UISearchBarDelegate {
    
    let searchCellID = "searchCellID"
    
    var podcasts = [PodcastResult]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Please search a podcast..."
        label.textAlignment = .center
        return label
    }()
    
    let aiv = UIActivityIndicatorView(style: .large)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        label.fillSuperview()
        setupCell()
        setupSearchController()
        
    }
    
    fileprivate func setupActivityIndicator() {
        
        view.addSubview(aiv)
        aiv.fillSuperview(padding: .init(top: 90, left: 0, bottom: 0, right: 0))
        aiv.startAnimating()

    }
    
    
    fileprivate func setupCell() {
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: searchCellID)

    }
    
    fileprivate func setupSearchController() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        aiv.startAnimating()
        fetchPodcastsWithSearchTerm(searchTerm: searchText)
        setupActivityIndicator()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, animations: {
            self.podcasts = []
            self.label.isHidden = false
            self.aiv.stopAnimating()
            self.collectionView.reloadData()
        })
    }
    
    fileprivate func fetchPodcastsWithSearchTerm(searchTerm: String) {
        
        let searchTerm = searchTerm.replacingOccurrences(of: " ", with: "+")
        
        let url = "https://itunes.apple.com/search?term=\(searchTerm)&entity=podcast"
        
        
        ServiceManager.shared.fetchPodcasts(url: url) { podcasts, err in
            
            if let err = err {
                print("Failed to fetch podcasts", err)
                return
            }
            

            guard let podcasts = podcasts?.results else {return}

            self.podcasts = podcasts

            DispatchQueue.main.async {
            
                self.label.isHidden = true
                self.collectionView.reloadData()
                
                if searchTerm == "" {
                    self.podcasts = []
                    self.label.isHidden = false
                    self.aiv.stopAnimating()
                    self.collectionView.reloadData()
                    return
                }
                
            }
        }
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if podcasts.count != 0 {
            aiv.stopAnimating()
        }

        return podcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellID, for: indexPath) as! SearchCell
        
        let podcast = podcasts[indexPath.item]
        
        cell.imageView.sd_setImage(with: URL(string: podcast.artworkUrl600 ?? ""))
        cell.podcastName.text = podcast.collectionName
        cell.artistName.text = podcast.artistName
        if podcast.trackCount == 1 {
            cell.trackCount.text = String("\(podcast.trackCount ?? .zero) episode")
        } else {
            cell.trackCount.text = String("\(podcast.trackCount ?? .zero) episodes")
        }
    
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedPodcast = podcasts[indexPath.item]
        print(selectedPodcast.collectionId)
        guard let collectionID = selectedPodcast.collectionId else {return}
        
        let episodesController = EpisodesController()
        navigationController?.pushViewController(episodesController, animated: true)
        episodesController.navigationItem.title = selectedPodcast.collectionName
        
        guard let feedUrl = selectedPodcast.feedUrl else {return}
        print(feedUrl)
        
        guard let url = URL(string: feedUrl) else {return}
        
        
        let parser = FeedParser(URL: url)
        
        parser.parseAsync { result in
            
            
            switch result {
            case .success(let feed):
                
                switch feed {
                case let .rss(feed):
                    var episodes = [RSSFeedItem]()
                    
                    feed.items?.forEach({ episode in
                        episodes.append(episode)
                    })
                    episodesController.episodes = episodes
                    DispatchQueue.main.async {
                        episodesController.collectionView.reloadData()
                    }
                    break
                case .atom(_):
                    break
                case .json(_):
                    break
                }
                
                
                
            case .failure(let err):
                print(err)
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
       
                
        // For artist name
        
        
//        episodesController.podcast = selectedPodcast
//
//        let url = "https://itunes.apple.com/lookup?id=\(collectionID)&country=US&media=podcast&entity=podcastEpisode&limit=40"
//        ServiceManager.shared.fetchEpisodes(url: url) { episodes, err in
//
//            var filteredEpisodes = [EpisodeResult]()
//
//            if let err = err {
//                print("Failed to get episodes", err)
//                return
//            }
//
//            guard let episodesItems = episodes?.results else {return}
//
//            episodesItems.forEach { item in
//                if item.episodeContentType == "audio" {
//                    filteredEpisodes.append(item)
//                } else {
//                    return
//                }
//            }
//
//
//            episodesController.episodes = filteredEpisodes
//            DispatchQueue.main.async {
//                episodesController.collectionView.reloadData()
//            }
//        }
        
    }
    
}




extension SearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: (view.frame.width - 48), height: 120)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
}
