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
        return iw
    }()
    
    let podcastName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let artistName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let trackCount: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.7294118404, green: 0.7294118404, blue: 0.7294118404, alpha: 1)
        return label
    }()
    
    let separationLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        
        addSubview(imageView)
        imageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil)
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.constrainWidth(constant: 92)
        imageView.constrainHeight(constant: 92)
        
        let stackView = UIStackView(arrangedSubviews: [podcastName, artistName, trackCount])
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.spacing = 4
        stackView.anchor(top: nil, leading: imageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        stackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        addSubview(separationLine)
        separationLine.anchor(top: nil, leading: stackView.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        separationLine.constrainHeight(constant: 0.5)
    }
    
    
}
