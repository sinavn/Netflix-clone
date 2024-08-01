//
//  HeroHeaderUIView.swift
//  Netflix clone
//
//  Created by Sina Vosough Nia on 4/23/1403 AP.
//

import UIKit
import SDWebImage

class HeroHeaderUIView: UIView {

    private let heroImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
//        imageView.image = UIImage(named: "waves")
        return imageView
    }()
    private let playButton : UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false // false if adding constraints manually
        return button
    }()
    private let downloadButton : UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: -  init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds // give frame to imageView
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // create gradient layer
     func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor , UIColor.systemBackground.cgColor
        ]
         gradientLayer.name = "gradientLayer"
        gradientLayer.frame = bounds // give frame to gradientLayer
        layer.addSublayer(gradientLayer)
    }
    
    private func applyConstraints (){
        let playButtonConstraints = [
//            playButton.trailingAnchor.constraint(equalTo: 10),
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    func configHeroImage (model:Movie?){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500"+(model?.backdropPath ?? ""))else{return}
        heroImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        heroImageView.sd_setImage(with: url)
    }
}
