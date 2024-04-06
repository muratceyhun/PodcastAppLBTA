//
//  FavoriteCell.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 2.04.2024.
//

import UIKit


class FavoriteCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iw = UIImageView()
        iw.backgroundColor = .black
        iw.layer.cornerRadius = 12
        iw.clipsToBounds = true
        return iw
    }()
    
    let podcastName: UILabel = {
        let name = UILabel()
        name.text = "Podcast Name"
        name.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return name
    }()
    
    let artistName: UILabel = {
        let name = UILabel()
        name.text = "Artist Name"
        name.textColor = .lightGray
        return name
    }()
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        addSubview(podcastName)
        podcastName.anchor(top: imageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        podcastName.constrainHeight(constant: 40)
        
        addSubview(artistName)
        artistName.anchor(top: podcastName.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}