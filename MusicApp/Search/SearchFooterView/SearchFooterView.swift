//
//  SearchFooterView.swift
//  MusicApp
//
//  Created by Сергей Иванов on 07.01.2021.
//

import UIKit


class SearchFooterView: UIView {
    
    var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.hidesWhenStopped = true
        return loader
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addSubview(loader)
        addSubview(label)
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        loader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        loader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: loader.bottomAnchor, constant: 10).isActive = true
        
    }
    
    func showLoader() {
        loader.startAnimating()
        label.isHidden = false
        
    }
    
    func hideLoader() {
        loader.stopAnimating()
        label.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
