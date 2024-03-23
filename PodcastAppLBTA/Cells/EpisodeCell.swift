//
//  EpisodeCell.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 18.03.2024.
//

import UIKit
import FeedKit

class EpisodeCell: UICollectionViewCell {
    
    var episode: RSSFeedItem? {
        didSet {
            
            guard let imageUrl = episode?.iTunes?.iTunesImage?.attributes?.href else {return}
            print("-----")
            print(imageUrl)
            imageView.sd_setImage(with: URL(string: imageUrl))
            episodeName.text = episode?.title
            episodeDescription.text = episode?.description

//    MARK: - Date Formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            dateFormatter.locale = Locale(identifier: "en_US")
            dateLabel.text = dateFormatter.string(from: episode?.pubDate ?? Date())

        }
    }
    

    
    
    let imageView: UIImageView = {
        let iw = UIImageView()
        iw.backgroundColor = .red
        iw.layer.cornerRadius = 12
        iw.clipsToBounds = true
        return iw
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12.11.2020"
        return label
    }()
    
    
    let episodeName: UILabel = {
        let label = UILabel()
        label.text = "Episode Name"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    let episodeDescription: UILabel = {
        let label = UILabel()
        label.text = "Description"
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundColor = .white
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
        
        let verticalStackView = UIStackView(arrangedSubviews: [dateLabel, episodeName, episodeDescription])
        addSubview(verticalStackView)
        verticalStackView.axis = .vertical
        verticalStackView.anchor(top: imageView.topAnchor, leading: imageView.trailingAnchor, bottom: imageView.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        verticalStackView.distribution = .fillProportionally
    }
    
    
    
    
}
