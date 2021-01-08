//
//  UIViewExtension.swift
//  MusicApp
//
//  Created by Сергей Иванов on 08.01.2021.
//

import UIKit


extension UIView {
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as! T
    }
}
