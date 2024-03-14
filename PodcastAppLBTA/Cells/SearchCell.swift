//
//  SearchCell.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 14.03.2024.
//

import UIKit


class SearchCell: UICollectionViewCell {
    
    
    let imageView: UIImageView = {
        let iw = UIImageView()
        iw.layer.cornerRadius = 12
        iw.clipsToBounds = true
        iw.backgroundColor = .yellow
        return iw
    }()
    
    let podcastName: UILabel = {
        let label = UILabel()
        label.text = "Podcast Name"
        return label
    }()
    
    let artistName: UILabel = {
        let label = UILabel()
        label.text = "Artist Name"
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        
        addSubview(imageView)
        imageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil)
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.constrainWidth(constant: 72)
        imageView.constrainHeight(constant: 72)
        
        let stackView = UIStackView(arrangedSubviews: [podcastName, artistName])
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.spacing = 4
        stackView.anchor(top: nil, leading: imageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        stackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    
}
