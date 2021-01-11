//
//  MainTabBar.swift
//  MusicApp
//
//  Created by Сергей Иванов on 05.01.2021.
//

import UIKit


class TabBarViewController: UITabBarController {
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    var trackView: TrackView!
    var maxTop: NSLayoutConstraint?
    var minTop: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        tabBar.tintColor = .purple
        
        searchVC.trackViewDelegate = self
    
        viewControllers = [
            generateViewController(rootViewController: searchVC, image: UIImage(systemName: "magnifyingglass")!, title: "Search"),
            generateViewController(rootViewController: LibraryViewController(), image: UIImage(systemName: "music.note.list")!, title: "Library")
        ]
        
    }
    
    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UINavigationController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.navigationBar.topItem?.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        return navigationVC
    }
    
    private func setupTrackView() {
        trackView = TrackView.loadFromNib()
        trackView.delegate = searchVC
        trackView.trackViewDelegate = self
        view.insertSubview(trackView, belowSubview: tabBar)
        
        maxTop = trackView.topAnchor.constraint(equalTo: view.topAnchor)
        minTop = trackView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottom = trackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        trackView.translatesAutoresizingMaskIntoConstraints = false
        maxTop?.isActive = true
        trackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottom?.isActive = true
        
        tabBar.alpha = 0
    }

}

extension TabBarViewController: TrackViewDelegate {
    
    func maxSizeTrackView(viewModel: Track?) {
        if trackView == nil {
            setupTrackView()
        }
        self.minTop?.isActive = false
        bottom?.constant = 0
        self.maxTop?.isActive = true
        
        self.tabBar.alpha = 0
        trackView.miniPlayer.alpha = 0
        trackView.maxPlayer.alpha = 1
        
        if let viewModel = viewModel {
            trackView.set(viewModel: viewModel)
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func minSizeTrackView() {
        self.maxTop?.isActive = false
        bottom?.constant = view.frame.height
        self.minTop?.isActive = true
        
        trackView.miniPlayer.alpha = 1
        trackView.maxPlayer.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
        }, completion: nil)
    }
    
}


