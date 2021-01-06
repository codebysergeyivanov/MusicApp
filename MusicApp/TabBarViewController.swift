//
//  MainTabBar.swift
//  MusicApp
//
//  Created by Сергей Иванов on 05.01.2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        tabBar.tintColor = .purple
        
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    
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

}
