//
//  DownloadsController.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 13.03.2024.
//

import UIKit
import SwipeCellKit


class DownloadsController: BaseListController, SwipeCollectionViewCellDelegate {
   
    let downloadsCellID = "downloadsCellID"
    
    var downloadedEpisodes = UserDefaults.standard.fetchDownloadedEpisodes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        downloadedEpisodes = UserDefaults.standard.fetchDownloadedEpisodes()
        collectionView.reloadData()
    }
    
    fileprivate func setupCollectionView() {
        
        collectionView.register(DownloadCell.self, forCellWithReuseIdentifier: downloadsCellID)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadedEpisodes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: downloadsCellID, for: indexPath) as! DownloadCell
        cell.delegate = self
        cell.episode = downloadedEpisodes[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        let selectedEpisode = downloadedEpisodes[indexPath.item]
        
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { _, _ in
            
            self.downloadedEpisodes.remove(at: indexPath.item)
            self.collectionView.deleteItems(at: [indexPath])
            UserDefaults.standard.deleteEpisode(episode: selectedEpisode)
            self.downloadedEpisodes = UserDefaults.standard.fetchDownloadedEpisodes()
            
            
        }
        
        
        return [deleteAction]
        
    }

}

extension DownloadsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: (view.frame.width - 48), height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 1
    }
    
}


