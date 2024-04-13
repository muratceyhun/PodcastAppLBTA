//
//  EpisodesController.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 18.03.2024.
//

import UIKit
import FeedKit
import SwipeCellKit

class EpisodesController: BaseListController, SwipeCollectionViewCellDelegate {
   
    var podcast: PodcastResult? {
        didSet {
            navigationItem.title = podcast?.collectionName
        }
    }
    
    let cellID = "cellID"
    
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupActivityIndicator()
        setupFavButton()
    }
    
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: cellID)
    }
    
   
    
    fileprivate func setupFavButton() {
        
        
        let favoritePodcasts = UserDefaults.standard.fetchFavoritePodcasts()
        
        if favoritePodcasts.firstIndex(where: {$0.collectionId == self.podcast?.collectionId}) != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .done, target: self, action: #selector(handleHeartClicked))
        } else {
            navigationItem.rightBarButtonItems =
            [
                UIBarButtonItem(title: "Favorite", style: .done, target: self, action: #selector(handleSaveFavPodcasts))
//                UIBarButtonItem(title: "Fetch", style: .done, target: self, action: #selector(handleFetchFavs))
            ]
        }
        
    }
    
    @objc func handleHeartClicked() {
        print("Heart....")
    }
    
    let favKey = "favKey"

    @objc func handleSaveFavPodcasts() {
   
        print("Saving podcast...")
        
        guard let podcast = podcast else {return}

//        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favKey) else {return}

        do {
//            guard let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastsData) as? [PodcastResult] else {return}
            let savedPodcasts = UserDefaults.standard.fetchFavoritePodcasts()
            var listOfPodcasts = savedPodcasts
            listOfPodcasts.append(podcast)
            let data = try NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: favKey)
            showBadgeHighligt()
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .done, target: self, action: nil)
        } catch let err {
            print("Failed to get array", err)
        }
        
        
    
        
//        ----
        
//            var listOfPodcasts = [PodcastResult]()
//            listOfPodcasts.append(podcast)
//            do {
//                let data = try NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)
//                UserDefaults.standard.set(data, forKey: favKey)
//            } catch let err {
//                print("Failed to save podcast", err)
//            }
        
    }
    
    fileprivate func showBadgeHighligt() {
        
        
        guard let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        else {return}
        
        guard let mainTabBarController = keyWindow.rootViewController as? BaseTabBarController else {return}
        
        mainTabBarController.viewControllers?[1].tabBarItem.badgeValue = "New"
        
        
    }
    
    @objc fileprivate func handleFetchFavs() {
        
        print("Fetching Podcast...")
        
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.favKey) else {return}
        do {
            
            let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [PodcastResult]
            guard let savedPodcasts = savedPodcasts else {return}
            savedPodcasts.forEach{print($0.collectionName ?? "", "|", $0.artistName ?? "")}
        } catch let err {
            print("Failed to fetch podcast...", err)
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
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> SwipeCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! EpisodeCell
        cell.delegate = self
        let episode = episodes[indexPath.item]
        cell.episode = episode
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }
       
        let selectedEpisode = episodes[indexPath.item]
        print(selectedEpisode.title ?? "")
        let downloadAction = SwipeAction(style: .default, title: "Download") { _, _ in
            print("Downloading...")
            ServiceManager.shared.downloadEpisode(episode: selectedEpisode)

            UserDefaults.standard.downloadEpisode(episode: selectedEpisode)
            
        }
        
        
        return [downloadAction]
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
