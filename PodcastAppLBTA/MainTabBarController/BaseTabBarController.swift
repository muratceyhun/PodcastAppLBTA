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
    
    fileprivate func setupFloatView() {
        
        let playerView = UIView()
        playerView.backgroundColor = .lightGray
//        view.addSubview(playerView)
        view.insertSubview(playerView, belowSubview: tabBar)
//        playerView.anchor(top: tabBar.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: -100, left: 0, bottom: 0, right: 0))
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        maximizeFloatViewConstant = playerView.topAnchor.constraint(equalTo: view.topAnchor)
        maximizeFloatViewConstant?.isActive = false
        minimizeFloatViewConstant = playerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizeFloatViewConstant?.isActive = true
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        perform(#selector(maximizeFloatView), with: nil, afterDelay: 2)
        
    }
    
    @objc func minimizeFloatView() {
        
    
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            
            self.maximizeFloatViewConstant?.isActive = false
            self.minimizeFloatViewConstant?.isActive = true
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    @objc func maximizeFloatView() {
        
    
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            
            self.maximizeFloatViewConstant?.isActive = true
            self.minimizeFloatViewConstant?.isActive = false
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

