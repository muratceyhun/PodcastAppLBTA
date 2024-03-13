//
//  BaseTabBarController.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 13.03.2024.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        
    }
    
    fileprivate func setupViewControllers() {
        
        view.backgroundColor = .white
        viewControllers =
        [
            creatingNavController(viewController: FavoritesController(), navTitle: "Favorites", tabTitle: "Favorites", imageName: "beats.headphones"),
            creatingNavController(viewController: SearchController(), navTitle: "Search", tabTitle: "Search", imageName: "magnifyingglass"),
            creatingNavController(viewController: DownloadsController(), navTitle: "Downloads", tabTitle: "Downloads", imageName: "waveform")
            
        ]
    }
    
    
    //MARK: - Helper Functions
    
    
    fileprivate func creatingNavController(viewController: UIViewController, navTitle: String, tabTitle: String, imageName: String) -> UINavigationController {
        
        let viewController = viewController
        viewController.navigationItem.title = navTitle

        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        
        navController.tabBarItem.title = tabTitle
        navController.tabBarItem.image = UIImage(systemName: imageName)
        
        return navController
        
    }


}

