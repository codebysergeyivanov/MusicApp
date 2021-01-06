//
//  UIViewControllerExtension.swift
//  MusicApp
//
//  Created by Сергей Иванов on 06.01.2021.
//

import Foundation
import UIKit


extension UIViewController {
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)

        if let vc = storyboard.instantiateInitialViewController() as? T {
            return vc
        }
        
        fatalError("Error: No initial view controller \(name) in storyboard")
    }
}
