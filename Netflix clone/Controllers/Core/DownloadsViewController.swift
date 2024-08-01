//
//  DownloadsViewController.swift
//  Netflix clone
//
//  Created by Sina Vosough Nia on 4/22/1403 AP.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var titles : [TitleItem] = []
    
    let downloadTable : UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        view.addSubview(downloadTable)
        downloadTable.delegate = self
        downloadTable.dataSource = self
        getTitlesFromDataBase()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("download"), object: nil, queue: nil) {[weak self] _ in
            self?.getTitlesFromDataBase()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
    
     func getTitlesFromDataBase(){
        DataPersistenceManager.shared.fetchData {[weak self] result in
            switch result {
            case.success(let fetchedTitles):
                self?.titles = fetchedTitles
                self?.downloadTable.reloadData()
            case.failure(let error):
                print("error fetching dataa base \(error)")
            }
        }
    }
}
extension DownloadsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        let title = titles[indexPath.row]
        cell.configuePosterImage(model: MovieViewModel(movieTitle: title.originalTitle ?? title.originalName ?? ""
                                                       , posterURL: title.posterPath ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete :
            DataPersistenceManager.shared.deleteData(item: titles[indexPath.row]) {[weak self] result in
                switch result {
                case.success():
                    print("deleted")
                    self?.titles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case.failure(let error):
                    print(error)
                }
            
            }
        default :
            break
        }
    }
}
