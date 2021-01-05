//
//  TableViewController.swift
//  MusicApp
//
//  Created by Сергей Иванов on 05.01.2021.
//

import UIKit

class SearchViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
    }
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID")!
        cell.imageView?.image = UIImage(named: "pic")
        cell.textLabel?.text = "Рыбка моя \nФиллип Киркоров"
        cell.textLabel?.numberOfLines = 2
        return cell
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
