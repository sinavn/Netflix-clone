//
//  SearchViewController.swift
//  Netflix clone
//
//  Created by Sina Vosough Nia on 4/22/1403 AP.
//

import UIKit

class SearchViewController: UIViewController {

    private var titles : [Movie] = []
    
    private let searchTable : UITableView = {
       let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()
    private let searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultViewController())
        searchController.searchBar.placeholder = "Search for a Movie or TV show"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
        view.addSubview(searchTable)
        fetchDiscoverMovies()
    
        searchController.searchResultsUpdater = self
        searchTable.dataSource = self
        searchTable.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
    
    func fetchDiscoverMovies () {
        Task{
            do {
                let fetchedTitles = try await APICaller.shared.getTrendingMovies(get: .DiscoverMovies)
                titles = fetchedTitles
                searchTable.reloadData()
            } catch let error {
                print("error fetching discover movies \(error)")
            }
        }
    }

}
extension SearchViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        
        cell.configuePosterImage(model: MovieViewModel(movieTitle: titles[indexPath.row].title ?? "unknown title", posterURL: titles[indexPath.row].posterPath ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
}

extension SearchViewController : UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let textQuery=searchBar.text ,
              !textQuery.trimmingCharacters(in: .whitespaces).isEmpty ,
              textQuery.trimmingCharacters(in: .whitespaces).count > 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController

        else{return}
        Task{
            do{
                let searchResult = try await APICaller.shared.search(for: textQuery)
                resultController.fillSearchedMovies(titles: searchResult)
            }catch let error{
                print("error search movies \(error)")
            }
        }
    }
   
}
