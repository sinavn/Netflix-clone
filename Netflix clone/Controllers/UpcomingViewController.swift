//
//  UpcomingViewController.swift
//  Netflix clone
//
//  Created by Sina Vosough Nia on 4/22/1403 AP.
//

import UIKit

class UpcomingViewController: UIViewController {

    private var movies : [Movie] = []
    private let upcomingMoviesTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUpcomingMovies()
        view.addSubview(upcomingMoviesTableView)
        upcomingMoviesTableView.dataSource = self
        upcomingMoviesTableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingMoviesTableView.frame = view.bounds
    }

    func configureUpcomingMovies (){
        Task{
            do{
                let fetchedMovies = try await APICaller.shared.getTrendingMovies(get: .UpcomingMovies)
                self.movies = fetchedMovies
                self.upcomingMoviesTableView.reloadData()
            }catch let error {
                print("error fetching upcoming movies \(error)")
            }
        }
    }

}
extension UpcomingViewController:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        let movie = movies[indexPath.row]
        cell.configuePosterImage(model: MovieViewModel(movieTitle: movie.originalTitle ?? "unknown title", posterURL: movie.posterPath ?? ""))
        cell.backgroundColor = .systemBackground
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}
