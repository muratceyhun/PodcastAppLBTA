//
//  PodcastPlayerView.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 20.03.2024.
//

import UIKit
import FeedKit


class PodcastPlayerView: UIView {
    
    
    var episode: RSSFeedItem? {
        didSet {
            
            imageView.sd_setImage(with: URL(string: episode?.iTunes?.iTunesImage?.attributes?.href ?? ""))
            podcastName.text = episode?.title
            artistName.text = episode?.iTunes?.iTunesAuthor 
        }
    }
    

    
    
    let imageView: UIImageView = {
        let iw = UIImageView()
        iw.backgroundColor = .green
        iw.layer.cornerRadius = 24
        iw.clipsToBounds = true
        return iw
    }()
    
    let timeSlider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    let time1: UILabel = {
        let name = UILabel()
        name.text = "01:47"
        name.numberOfLines = 0
        name.textAlignment = .left
        return name
    }()
    
    let time2: UILabel = {
        let name = UILabel()
        name.text = "00:00:00"
        name.numberOfLines = 0
        name.textAlignment = .left
        return name
    }()
    
    
    let podcastName: UILabel = {
        let name = UILabel()
        name.text = "Podcast Name"
        name.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        name.numberOfLines = 0
        name.textAlignment = .center
        return name
    }()
    
    let artistName: UILabel = {
        let name = UILabel()
        name.text = "Artist Name"
        name.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        name.textAlignment = .center
        return name
    }()
    
    let backwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gobackward.15"), for: .normal)
//        button.constrainWidth(constant: 64)
//        button.constrainHeight(constant: 64)
        return button
    }()
        
    let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
//        button.constrainWidth(constant: 64)
//        button.constrainHeight(constant: 64)
        return button
    }()
    
    let forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "goforward.15"), for: .normal)
//        button.constrainWidth(constant: 64)
//        button.constrainHeight(constant: 64)
        return button
    }()
    
    let volumeSlider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    let volumeMin: UIImageView = {
        let iw = UIImageView()
        iw.image = UIImage(systemName: "speaker.fill")
        return iw
    }()
    
    let volumeMax: UIImageView = {
        let iw = UIImageView()
        iw.image = UIImage(systemName: "speaker.wave.2.fill")
        return iw
    }()
    
    
    
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.square"), for: .normal)
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCloseButton() {
        removeFromSuperview()
    }
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(imageView)
        imageView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 30, left: 30, bottom: 0, right: 30))
        imageView.constrainHeight(constant: 320)
        
        addSubview(timeSlider)
        timeSlider.anchor(top: imageView.bottomAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: imageView.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        addSubview(time1)
        time1.anchor(top: timeSlider.bottomAnchor, leading: timeSlider.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
        addSubview(time2)
        time2.anchor(top: timeSlider.bottomAnchor, leading: nil, bottom: nil, trailing: timeSlider.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
        addSubview(podcastName)
        podcastName.anchor(top: timeSlider.bottomAnchor, leading: timeSlider.leadingAnchor, bottom: nil, trailing: timeSlider.trailingAnchor, padding: .init(top: 48, left: 0, bottom: 0, right: 0))
        
        addSubview(artistName)
        artistName.anchor(top: podcastName.bottomAnchor, leading: timeSlider.leadingAnchor, bottom: nil, trailing: timeSlider.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))

        let stackView = UIStackView(arrangedSubviews: [backwardButton, playPauseButton, forwardButton])
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.anchor(top: artistName.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 30, bottom: 30, right: 30))
        stackView.constrainHeight(constant: 120)
        
        
        let volumeStackView = UIStackView(arrangedSubviews: [volumeMin, volumeSlider, volumeMax])
        volumeStackView.spacing = 12
        
        addSubview(volumeStackView)
        volumeStackView.anchor(top: stackView.bottomAnchor, leading: timeSlider.leadingAnchor, bottom: nil, trailing: timeSlider.trailingAnchor)
        

        addSubview(closeButton)
        closeButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 40, left: 0, bottom: 0, right: 40))
        closeButton.constrainHeight(constant: 64)
        closeButton.constrainWidth(constant: 64)
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
