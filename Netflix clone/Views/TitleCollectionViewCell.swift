//
//  TitleCollectionViewCell.swift
//  Netflix clone
//
//  Created by Sina Vosough Nia on 4/28/1403 AP.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let titleImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleImage)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleImage.frame = contentView.bounds
    }
    
    public func configureTitleImage (model:String?) {
        if let safeModel = model{
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500"+safeModel) else {return}
            titleImage.sd_imageIndicator = SDWebImageActivityIndicator.white
            titleImage.sd_setImage(with: url)
        }else{
            print("error getting collectionViewCell image")
        }
    }
}
