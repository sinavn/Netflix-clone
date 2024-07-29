//
//  HomeViewController.swift
//  Netflix clone
//
//  Created by Sina Vosough Nia on 4/22/1403 AP.
//

import UIKit

class HomeViewController: UIViewController {

    private let homeFeedtable : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    private let sectionHeaders:[String]=[
    "Trending Movies","Popular","Trending TVs", "Upcoming Movies" , "Top Rated"
    ]
    
    enum Section:Int {
        case trendingMovies = 0
        case popular = 1
        case trendingTvs = 2
        case upcomingMovies = 3
        case topRated = 4
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedtable )
        
        homeFeedtable.showsVerticalScrollIndicator = false
        homeFeedtable.delegate = self
        homeFeedtable.dataSource = self
        homeFeedtable.tableHeaderView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 400))
        configureNavBar()
        
//        Task{
//            let harry = try? await APICaller.shared.getTrailer(with:"harry")
//            print(harry)
//        }
//        navigationController?.pushViewController(TitlePreviewViewController(), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedtable.frame = view.bounds
    }
    private func configureNavBar(){
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image:UIImage(systemName: "person.circle"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
        
    }
    
}


extension HomeViewController : UITableViewDelegate , UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        let text = UILabel()
        text.text = sectionHeaders[section]
        text.font = .systemFont(ofSize: 18, weight: .semibold)
        text.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(text)
        
        NSLayoutConstraint.activate([
            text.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20) ,
        ])
        return containerView
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case Section.trendingMovies.rawValue:
            Task{
                do {
                    let fetchedMovies = try await APICaller.shared.getTrendingMovies(get: .TrendingMovies)
                    cell.configureMovieTitles(titles: fetchedMovies)
                } catch let error {
                    print(error)
                }
            }
        case Section.popular.rawValue:
            Task{
                do {
                    let fetchedMovies = try await APICaller.shared.getTrendingMovies(get: .PopularMovies)
                    cell.configureMovieTitles(titles: fetchedMovies)
                } catch let error {
                    print(error)
                }
            }
        case Section.trendingTvs.rawValue:
            Task{
                do {
                    let fetchedMovies = try await APICaller.shared.getTrendingMovies(get: .TrendingTVs)
                    cell.configureMovieTitles(titles: fetchedMovies)
                } catch let error {
                    print(error)
                }
            }
        case Section.upcomingMovies.rawValue:
            Task{
                do {
                    let fetchedMovies = try await APICaller.shared.getTrendingMovies(get: .UpcomingMovies)
                    cell.configureMovieTitles(titles: fetchedMovies)
                } catch let error {
                    print(error)
                }
            }
        case Section.topRated.rawValue:
            Task{
                do {
                    let fetchedMovies = try await APICaller.shared.getTrendingMovies(get: .TopRatedMovies)
                    cell.configureMovieTitles(titles: fetchedMovies)
                } catch let error {
                    print(error)
                }
            }
        default:
            break
        }
        cell.delegate = self
        return cell
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y+defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
     
    
}
extension HomeViewController : CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {
            let vc = TitlePreviewViewController()
            vc.configurePreview(with: viewModel)
            self.navigationController?.pushViewController(vc , animated: true)
        }
    }

}
