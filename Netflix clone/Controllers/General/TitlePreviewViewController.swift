//
//  TitlePreviewViewController.swift
//  Netflix clone
//
//  Created by Sina Vosough Nia on 5/7/1403 AP.
//

import UIKit
import WebKit
import YouTubeiOSPlayerHelper

class TitlePreviewViewController: UIViewController {
    
    let ytPlayer : YTPlayerView = {
        let player = YTPlayerView()
        player.translatesAutoresizingMaskIntoConstraints = false
        player.contentMode = .scaleAspectFit
        player.clipsToBounds = true
        return player
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.tintColor = .label
        label.text = "unknown title"
        return label
    }()
    
    let overViewLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.tintColor = .label
        label.numberOfLines = 0
        label.text = "inknown overview"
        return label
    }()
    
    let downloadButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        view.addSubview(downloadButton)
        view.addSubview(ytPlayer)
        configureConstraints()

    }
    func configurePreview (with model: TitlePreviewViewModel){
        titleLabel.text = model.title
        overViewLabel.text = model.titleOverview
        ytPlayer.load(withVideoId: model.videoID)
    }
    
    
    private func configureConstraints(){
        //webview constraints
        NSLayoutConstraint.activate([
            ytPlayer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ytPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 5),
            ytPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5),
            ytPlayer.heightAnchor.constraint(equalToConstant: 250)
        ])
        //title label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: ytPlayer.bottomAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            downloadButton.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 25),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
