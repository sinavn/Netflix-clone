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
        navigationItem.title = "Upcoming Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
 
        fetcheUpcomingMovies()
        view.addSubview(upcomingMoviesTableView)
        upcomingMoviesTableView.dataSource = self
        upcomingMoviesTableView.delegate = self
   
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingMoviesTableView.frame = view.bounds
    }

    func fetcheUpcomingMovies (){
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
        cell.configuePosterImage(model: MovieViewModel(movieTitle: movie.title ?? "unknown title", posterURL: movie.posterPath ?? ""))
        cell.backgroundColor = .systemBackground
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTitle = movies[indexPath.row]
        Task{
            do{
                let videoId = try await APICaller.shared.getTrailer(with: selectedTitle.title ?? selectedTitle.originalName ?? "" + "Trailer")
                let vc = TitlePreviewViewController()
                let viewModel = TitlePreviewViewModel(title: selectedTitle.title ?? selectedTitle.originalName ?? ""
                                              , videoID: videoId.first!.id.videoId,
                                              titleOverview: selectedTitle.overview ?? "")
                vc.configurePreview(with: viewModel)
                navigationController?.pushViewController(vc, animated: true)
            
            }catch{
                print(error)
            }
        }
       
    }
    
}
