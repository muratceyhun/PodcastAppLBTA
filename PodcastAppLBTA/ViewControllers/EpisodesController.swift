//
//  EpisodesController.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 18.03.2024.
//

import UIKit

class EpisodesController: BaseListController {
    
    
    let cellID = "cellID"
    
//    var episodes: Episode?
    var episodes = [EpisodeResult]()
    var podcast: PodcastResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
        
        let podcastPlayerView = PodcastPlayerView()
        podcastPlayerView.frame = self.view.frame
        keyWindow?.addSubview(podcastPlayerView)
        
        let episode = episodes[indexPath.item]
        
        podcastPlayerView.podcast = podcast
        podcastPlayerView.episode = episode

        
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
