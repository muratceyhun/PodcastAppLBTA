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
    
    var favoritePodcasts =  UserDefaults.standard.fetchFavoritePodcasts()
    
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
        
        favoritePodcasts = UserDefaults.standard.fetchFavoritePodcasts()
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
            let selectedPodcast = self.favoritePodcasts[selectedIndexPath.item]

            print(selectedPodcast.collectionId ?? "", selectedPodcast.collectionName ?? "")
            
            self.favoritePodcasts.remove(at: selectedIndexPath.item)
            self.collectionView.deleteItems(at: [selectedIndexPath])
            UserDefaults.standard.deletePodcast(podcast: selectedPodcast)
            self.favoritePodcasts = UserDefaults.standard.fetchFavoritePodcasts()
            
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
        
        ServiceManager.shared.fetchEpisodes(podcast: selectedPodcast) { episodes, err in
            
            if let err = err {
                print("Failed to fetch episodes with feed kit", err)
                return
            }
            guard let episodes = episodes else {return}
            episodesController.episodes = episodes
            DispatchQueue.main.async {
                episodesController.collectionView.reloadData()
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
        return .init(width: width, height: width + 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}
