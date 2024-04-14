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
        setupObservers()
    }
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }
    
    var timer: Timer?
    
    @objc func handleDownloadComplete(notification: Notification) {
        
        guard let episodeDownloadComplete = notification.object as? ServiceManager.EpisodeDownloadCompleteTuple else {return}
        
        guard let index = downloadedEpisodes.firstIndex(where: {$0.title == episodeDownloadComplete.episodeTitle}) else {return}
        downloadedEpisodes[index].fileUrl = episodeDownloadComplete.fileURL
        
    }
    
    @objc func handleDownloadProgress(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: Any] else {return}
        guard let episodeTitle = userInfo["title"] as? String else {return}
        guard let downloadProgress = userInfo["downloadProgress"] as? Double else {return}
        print(episodeTitle, "|", downloadProgress)
        
        guard let index = downloadedEpisodes.firstIndex(where: {$0.title == episodeTitle}) else {return}
        guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? DownloadCell else {return}
        cell.downloadProgressLabel.text = "\(Int(downloadProgress*100))%"
        
        if downloadProgress == 1 {
            cell.downloadProgressLabel.text = "100%"
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                cell.downloadProgressLabel.isHidden = true
            })
        }
    
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedEpisode = downloadedEpisodes[indexPath.item]
        
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        
        if selectedEpisode.fileUrl != nil {
            
            let tabBarController = keyWindow?.rootViewController as? BaseTabBarController
            tabBarController?.maximizeFloatView()
            
            tabBarController?.playerView.episode = selectedEpisode
        } else {
            
            let alertController = UIAlertController(title: "File URL not found", message: "Cannot find local file, play using stream URL instead.", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alertController, animated: true)
            
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else {return nil}
        let selectedEpisode = downloadedEpisodes[indexPath.item]
        
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { _, _ in
            self.downloadedEpisodes.remove(at: indexPath.item)
            self.collectionView.deleteItems(at: [indexPath])
            UserDefaults.standard.deleteEpisode(episode: selectedEpisode)
            self.downloadedEpisodes = UserDefaults.standard.fetchDownloadedEpisodes()
        }
        
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
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


