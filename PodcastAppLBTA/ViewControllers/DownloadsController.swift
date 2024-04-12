//
//  DownloadsController.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 13.03.2024.
//

import UIKit


class DownloadsController: BaseListController {
    
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
        cell.episode = downloadedEpisodes[indexPath.item]
        return cell
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


