//
//  CollectionViewTableViewCell.swift
//  Netflix clone
//
//  Created by Sina Vosough Nia on 4/22/1403 AP.
//

import UIKit

protocol CollectionViewTableViewCellDelegate : AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell:CollectionViewTableViewCell , viewModel : TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate : CollectionViewTableViewCellDelegate?
     
    private var movieTitles : [Movie] = []
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collection
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(collectionView)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    func configureMovieTitles (titles : [Movie]){
        movieTitles = titles
        self.collectionView.reloadData()
    }
}

extension CollectionViewTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell()}
        cell.configureTitleImage(model: movieTitles[indexPath.row].posterPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedMovie = movieTitles[indexPath.row]
        Task{
            do{
                let result = try await APICaller.shared.getTrailer(with: selectedMovie.title ?? selectedMovie.originalName ?? "" + "Trailer")
                guard let videoId = result.first?.id.videoId else {return}
                delegate?.collectionViewTableViewCellDidTapCell(self, viewModel: TitlePreviewViewModel(title: selectedMovie.title ?? selectedMovie.originalName ?? "unknown", videoID: videoId, titleOverview: selectedMovie.overview ?? "unknown overview "))
            }catch let error{
                print("error getting yotube video id \(error)")
            }
        }
    }
}
