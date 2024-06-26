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
    
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = .darkGray
        ai.hidesWhenStopped = true
        return ai
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        label.fillSuperview()
        setupCell()
        setupSearchController()
        setupActivityIndicator()
        
    }
    
    fileprivate func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.fillSuperview(padding: .init(top: 90, left: 0, bottom: 0, right: 0))
    }
    
 
    
    fileprivate func setupCell() {
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: searchCellID)

    }
    
    fileprivate func setupSearchController() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    
    var timer: Timer?

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        activityIndicator.startAnimating()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            ServiceManager.shared.fetchPodcasts(searchText: searchText) { podcasts, err in
                
                if let err = err {
                    print("Failed to fetch podcasts", err)
                    return
                }
                
                guard let podcasts = podcasts?.results else {return}
                self.podcasts = podcasts
                DispatchQueue.main.async {
                    
                    self.label.isHidden = true
                    self.collectionView.reloadData()
                    
                    if searchText == "" {
                        self.activityIndicator.stopAnimating()
                        self.podcasts = []
                        self.label.isHidden = false
                        self.collectionView.reloadData()
                        return
                    }
                    
                }
            }
        })
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, animations: {
            self.podcasts = []
            self.label.isHidden = false
            self.collectionView.reloadData()
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if podcasts.count != 0 {
            activityIndicator.stopAnimating()
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
        
        let episodesController = EpisodesController()
        episodesController.podcast = selectedPodcast
        navigationController?.pushViewController(episodesController, animated: true)
        
        ServiceManager.shared.fetchEpisodes(podcast: selectedPodcast) { episodes, err in
            
            if let err = err {
                print("Failed to fetch episodes", err)
                return
            }
            
            guard let episodes = episodes else {return}
            episodesController.episodes = episodes
            DispatchQueue.main.async {
                episodesController.collectionView.reloadData()
            }
            
            
        }

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
