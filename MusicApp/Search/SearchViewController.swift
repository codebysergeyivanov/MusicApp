//
//  SearchViewController.swift
//  MusicApp
//
//  Created by Сергей Иванов on 06.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SearchDisplayLogic: class
{
    func displaySomething(viewModel: Search.Something.ViewModel.ViewModelType)
}

class SearchViewController: UIViewController, SearchDisplayLogic
{
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic & SearchDataPassing)?
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
        setupSearchController()
        setupTableView()
        self.searchBar(searchController.searchBar, textDidChange: "Моргенштерн")
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TableViewCell.reuseId)
        tableView.tableFooterView = searchFooterView
    }
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    // MARK: Do something
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    var tracks: [Track] = []
    lazy var searchFooterView = SearchFooterView()
    var trackViewDelegate: TrackViewDelegate?
    
    
    func displaySomething(viewModel: Search.Something.ViewModel.ViewModelType)
    {
        switch viewModel {
        case .presentTracks(let tracks):
            self.tracks = tracks
            tableView.reloadData()
            searchFooterView.hideLoader()
        case .presentLoader:
            searchFooterView.showLoader()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseId) as! TableViewCell
        let trackCell = tracks[indexPath.row]
        cell.set(viewModel: trackCell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Enter the text above and press enter"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tracks.count == 0 ? 250 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trackViewModel = tracks[indexPath.row]
        trackViewDelegate?.maxSizeTrackView(viewModel: trackViewModel)
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            let request = Search.Something.Request.RequestType.getTracks(searchText: searchText)
            self.interactor?.doSomething(request: request)
        })
    }
}

// MARK: - witchTrackDelegate
extension SearchViewController: SwitchTrackDelegate {
    func switchTrack(isForwardTrack: Bool) -> Track? {
        guard let selectedIndex = tableView.indexPathForSelectedRow else { return nil }
        tableView.deselectRow(at: selectedIndex, animated: true)
        var indexPath: IndexPath!
        if isForwardTrack {
            indexPath = IndexPath(row: selectedIndex.row + 1, section: selectedIndex.section)
            if indexPath.row == tracks.count {
                indexPath.row = 0
            }
        } else {
            indexPath = IndexPath(row: selectedIndex.row - 1, section: selectedIndex.section)
            if indexPath.row < 0 {
                indexPath.row = tracks.count - 1
            }
        }
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        return tracks[indexPath.row]
    }
    
    func playNextTrack() -> Track? {
        return switchTrack(isForwardTrack: true)
        
    }
    
    func playPreviousTrack() -> Track? {
        return switchTrack(isForwardTrack: false)
    }
    
}
