//
//  BaseListController.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 13.03.2024.
//

import UIKit

class BaseListController: UICollectionViewController {

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
