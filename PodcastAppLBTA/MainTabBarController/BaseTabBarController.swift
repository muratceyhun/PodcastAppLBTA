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
        setupFloatView()
   
    
        let tabBarAppearance = UITabBarAppearance()
//        tabBarAppearance.configureWithOpaqueBackground()
//        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.configureWithDefaultBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    

    
    fileprivate func setupViewControllers() {
        
        view.backgroundColor = .white
        viewControllers =
        
        [
            creatingNavController(viewController: SearchController(), navTitle: "Search", tabTitle: "Search", imageName: "magnifyingglass"),
            creatingNavController(viewController: FavoritesController(), navTitle: "Favorites", tabTitle: "Favorites", imageName: "beats.headphones"),
            creatingNavController(viewController: DownloadsController(), navTitle: "Downloads", tabTitle: "Downloads", imageName: "waveform")
            
        ]
    }
    
    var maximizeFloatViewConstant: NSLayoutConstraint?
    var minimizeFloatViewConstant: NSLayoutConstraint?
    
    
    let playerView = PodcastPlayerView()

    fileprivate func setupFloatView() {
//        view.addSubview(playerView)
        view.insertSubview(playerView, belowSubview: tabBar)

        playerView.translatesAutoresizingMaskIntoConstraints = false
        maximizeFloatViewConstant = playerView.topAnchor.constraint(equalTo: view.topAnchor)
        maximizeFloatViewConstant?.isActive = false
        minimizeFloatViewConstant = playerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -80)
        minimizeFloatViewConstant?.isActive = false
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        
        playerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
    }
    
    @objc func handleTapMaximize() {
        print("3333")
        self.maximizeFloatView()
    }
        
    @objc func minimizeFloatView() {


    
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.maximizeFloatViewConstant?.isActive = false
            self.minimizeFloatViewConstant?.isActive = true
            self.tabBar.isHidden = false
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    @objc func maximizeFloatView() {
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            
            
            self.maximizeFloatViewConstant?.isActive = true
            self.minimizeFloatViewConstant?.isActive = false
            self.tabBar.isHidden = true
            self.view.layoutIfNeeded()
            
            
        }
        
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

