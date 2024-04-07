//
//  FavoritesController.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 13.03.2024.
//

import UIKit
import FeedKit

class FavoritesController: BaseListController {
    
    let cellID = "cellID"
    
    var favoritePodcasts =  UserDefaults.standard.savedPodcasts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        else {return}
        
        guard let mainTabBarController = keyWindow.rootViewController as? BaseTabBarController else {return}
        
        favoritePodcasts = UserDefaults.standard.savedPodcasts()
        collectionView.reloadData()
        mainTabBarController.viewControllers?[1].tabBarItem.badgeValue = nil
        
        
    }
    
   
    
    fileprivate func setupCollectionView() {
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        
        let location = gesture.location(in: collectionView)
        guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else {return}
        print(selectedIndexPath.item)
        
        let alertController = UIAlertController(title: "Remove Podcast?", message: nil, preferredStyle: .actionSheet)
        present(alertController, animated: true)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            print("Removing podcast...")
            
            // For animation, you need to delete podcast from that array at first and than from collectionview...
            
            self.favoritePodcasts.remove(at: selectedIndexPath.item)
            self.collectionView.deleteItems(at: [selectedIndexPath])
            

        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("Cancel")
        }))
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedPodcast = favoritePodcasts[indexPath.item]
        
        let episodesController = EpisodesController()
        episodesController.podcast = selectedPodcast
        navigationController?.pushViewController(episodesController, animated: true)
        
        guard let feedUrl = selectedPodcast.feedUrl else {return}
        print(feedUrl)
        
        guard let url = URL(string: feedUrl) else {return}
        
        
        DispatchQueue.global(qos: .background).async {
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
        
        
        
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePodcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FavoriteCell
        let favoritePodcast = favoritePodcasts[indexPath.item]
        cell.favoritePodcast = favoritePodcast
        return cell
    }
}


//MARK: - UICollectionViewFlowLayout


extension FavoritesController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width - 3 * 16) / 2
        return .init(width: width, height: width + 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}
