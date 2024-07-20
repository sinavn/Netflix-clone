//
//  MovieTableViewCell.swift
//  Netflix clone
//
//  Created by Sina Vosough Nia on 4/30/1403 AP.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {

    static let identifier = "MovieTableViewCell"
    private let moviePoster : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let titleLabel : UILabel = {
        let uiLabel = UILabel()
        uiLabel.text = "empty"
        uiLabel.numberOfLines = 0
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        return uiLabel
    }()
    
    private let playButton : UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle",withConfiguration:UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(moviePoster)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        configureConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        moviePoster.frame = contentView.bounds
//        playButton.frame = bounds
    }
    
    private func configureConstraints(){
        //movie poster constraints
        NSLayoutConstraint.activate([
            moviePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            moviePoster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            moviePoster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            moviePoster.widthAnchor.constraint(equalToConstant: 100)
        ])
        //title label constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -10)
        ])
        // play botton constraints
        NSLayoutConstraint.activate([
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    public func configuePosterImage (model:MovieViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500"+model.posterURL) else{return}
            moviePoster.sd_imageIndicator = SDWebImageProgressIndicator()
            moviePoster.sd_setImage(with: url)
        titleLabel.text = model.movieTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
