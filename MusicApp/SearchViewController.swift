//
//  TableViewController.swift
//  MusicApp
//
//  Created by Сергей Иванов on 05.01.2021.
//

import UIKit

class SearchViewController: UITableViewController {
    let networkService = NetworkService()
    let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    var tracks: [Track] = []

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
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID")!
        cell.imageView?.image = UIImage(named: "pic")
        let track = tracks[indexPath.row]
        cell.textLabel?.text = "\(track.trackName) \n\(track.artistName)"
        cell.textLabel?.numberOfLines = 2
        return cell
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {[weak self]_ in
            self?.networkService.fetchTracks(searchText: searchText) {
                objects in
                self?.tracks = objects?.results ?? []
                self?.tableView.reloadData()
            }
        })
    }
}
