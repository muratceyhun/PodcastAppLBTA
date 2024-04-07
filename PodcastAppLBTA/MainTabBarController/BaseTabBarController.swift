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
        
        setupTabBarApperance()
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
    
    fileprivate func setupTabBarApperance() {
        let tabBarAppearance = UITabBarAppearance()
//        tabBarAppearance.configureWithOpaqueBackground()
//        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.configureWithDefaultBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var maximizeFloatViewConstant: NSLayoutConstraint?
    var minimizeFloatViewConstant: NSLayoutConstraint?
    
    
    let playerView = PodcastPlayerView()
    
    var panGesture: UIPanGestureRecognizer?
    
    
    fileprivate func setupFloatView() {
//        view.addSubview(playerView)
        view.insertSubview(playerView, belowSubview: tabBar)

        playerView.translatesAutoresizingMaskIntoConstraints = false
        maximizeFloatViewConstant = playerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizeFloatViewConstant?.isActive = true
        minimizeFloatViewConstant = playerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -88)
        minimizeFloatViewConstant?.isActive = false
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height).isActive = true
        
        
        playerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        guard let panGesture = panGesture else {return}
        playerView.addGestureRecognizer(panGesture)
        
    }
    
 
    
    @objc func handleTapMaximize() {
        self.maximizeFloatView()
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .changed {
            handleChanged(gesture: gesture)
        } else if gesture.state == .ended {
            handleEnded(gesture: gesture)
        }
    }
    
    
    func handleChanged(gesture: UIPanGestureRecognizer) {
        var translationY = gesture.translation(in: view.superview).y
        
        if translationY < 0 {
            playerView.transform = CGAffineTransform(translationX: 0, y: translationY)
            print(translationY)
            translationY = -translationY
            playerView.miniPlayerView.alpha = 40 / translationY
            playerView.imageView.alpha = 1 / 400 * translationY
            playerView.closeButton.alpha = 1 / 400 * translationY
            return
        }
    }
    
    func handleEnded(gesture: UIPanGestureRecognizer) {
        
        var translationY = gesture.translation(in: view.superview).y
        let threshold: CGFloat = view.frame.size.height / 3
        translationY = -translationY
        print(translationY, threshold)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
            
            self.playerView.transform = .identity
            
            if translationY > threshold {
                    self.playerView.miniPlayerView.alpha = 0
                    self.playerView.imageView.alpha = 1
                    self.playerView.closeButton.alpha = 1
                    self.maximizeFloatView()
                    print("maximize")
            } else {
                    print("minimize")
                    self.playerView.miniPlayerView.alpha = 1
                    self.playerView.imageView.alpha = 0
                    self.playerView.closeButton.alpha = 0

            }
        }
    }
    
    
    @objc func minimizeFloatView() {

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            
            self.maximizeFloatViewConstant?.isActive = false
            self.minimizeFloatViewConstant?.isActive = true
            self.tabBar.isHidden = false
            self.playerView.imageView.alpha = 0
            self.playerView.closeButton.alpha = 0
            self.playerView.miniPlayerView.alpha = 1
            self.view.layoutIfNeeded()
            self.panGesture?.isEnabled = true
            
        }
    }
    
    @objc func maximizeFloatView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            
            self.minimizeFloatViewConstant?.isActive = false
            self.maximizeFloatViewConstant?.constant = 0
            self.maximizeFloatViewConstant?.isActive = true
            self.playerView.imageView.alpha = 1
            self.playerView.closeButton.alpha = 1
            self.playerView.miniPlayerView.alpha = 0
            self.panGesture?.isEnabled = false
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

