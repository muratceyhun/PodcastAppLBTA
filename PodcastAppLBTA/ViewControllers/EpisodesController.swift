//
//  EpisodesController.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 18.03.2024.
//

import UIKit
import FeedKit

class EpisodesController: BaseListController {
    
    
    var podcast: PodcastResult? {
        didSet {
            navigationItem.title = podcast?.collectionName
        }
    }
    
    let cellID = "cellID"
    
    var episodes = [RSSFeedItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: cellID)
        setupActivityIndicator()
        setupFavButton()
    }
    
    
    fileprivate func setupFavButton() {
        navigationItem.rightBarButtonItems =
        [
            UIBarButtonItem(title: "Favorite", style: .done, target: self, action: #selector(handleSaveFavPodcasts)),
            UIBarButtonItem(title: "Fetch", style: .done, target: self, action: #selector(handleFetchFavs))
        ]
    }
    
    let favKey = "favKey"
    
    
    @objc func handleSaveFavPodcasts() {
        print("Saving...")
        
        guard let podcast = podcast else {return}
        
        do {
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: podcast, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: favKey)
        } catch let err {
            print("Failed to save podcats", err)
        }

    }
    
    @objc fileprivate func handleFetchFavs() {
        print("Fetching saved podcasts...")
    
        
        guard let data = UserDefaults.standard.data(forKey: favKey) else {return}
        do {
            let podcast = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? PodcastResult
            print(podcast?.collectionName ?? "", "", podcast?.artistName ?? "")
        } catch let err {
            print("Failed to fetch podcast...")
        }

    }
    
    let activityIndicator = UIActivityIndicatorView(style: .large)

    
    fileprivate func setupActivityIndicator() {
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .darkGray
        view.addSubview(activityIndicator)
        activityIndicator.fillSuperview()
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if episodes.isEmpty {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        return episodes.count
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! EpisodeCell
        
        let episode = episodes[indexPath.item]
        cell.episode = episode
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        
        
        let tabBarController = keyWindow?.rootViewController as? BaseTabBarController
        tabBarController?.maximizeFloatView()
        
        let episode = episodes[indexPath.item]
        tabBarController?.playerView.episode = episode
        
        
//        let podcastPlayerView = PodcastPlayerView()
//        podcastPlayerView.frame = self.view.frame
//        keyWindow?.addSubview(podcastPlayerView)
//
//        let episode = episodes[indexPath.item]
//
//        podcastPlayerView.episode = episode
        
    }
}


extension EpisodesController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: (view.frame.width - 48), height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 1
    }
    
}
