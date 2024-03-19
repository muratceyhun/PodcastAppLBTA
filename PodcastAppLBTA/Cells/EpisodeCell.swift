//
//  EpisodeCell.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 18.03.2024.
//

import UIKit

class EpisodeCell: UICollectionViewCell {
    
    var episode: EpisodeResult? {
        didSet {
            
            imageView.sd_setImage(with: URL(string: episode?.artworkUrl600 ?? ""))
            episodeName.text = episode?.trackName ?? ""
            episodeDescription.text = episode?.description ?? ""
            
    //MARK: - Date Formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US")
            let date: Date = dateFormatter.date(from: episode?.releaseDate ?? "") ?? Date()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            dateLabel.text = dateFormatter.string(from: date)
            
        }
    }
    
    
    let imageView: UIImageView = {
        let iw = UIImageView()
        iw.layer.cornerRadius = 12
        iw.clipsToBounds = true
        return iw
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    let episodeName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let episodeDescription: UILabel = {
        let label = UILabel()
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
        verticalStackView.distribution = .fillEqually
    }
    
    
    
    
}
