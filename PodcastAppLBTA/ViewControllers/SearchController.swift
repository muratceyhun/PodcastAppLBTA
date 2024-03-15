//
//  SearchController.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 13.03.2024.
//

import UIKit
import SDWebImage


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
    
}


extension SearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: (view.frame.width - 48), height: 120)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
}
