//
//  SearchResultViewController.swift
//  Netflix clone
//
//  Created by Sina Vosough Nia on 5/5/1403 AP.
//

import UIKit

class SearchResultViewController: UIViewController {
    
     private var searchedMovies : [Movie] = []
     private let searchResultCollectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collection
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .green
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
        
        if let layout = searchResultCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: view.bounds.width / 3 - 10, height: 200)
        }
    }
    func fillSearchedMovies (titles : [Movie]){
        searchedMovies = titles
        searchResultCollectionView.reloadData()
    }
}

extension SearchResultViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell()}
        
        cell.configureTitleImage(model: searchedMovies[indexPath.row].posterPath ?? "")
        
        return cell
    }
    
    
}
