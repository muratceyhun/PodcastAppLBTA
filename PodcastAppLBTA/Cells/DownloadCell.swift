//
//  DownloadCell.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 8.04.2024.
//

import UIKit
import FeedKit
import SwipeCellKit

class DownloadCell: SwipeCollectionViewCell {
    
        
        var episode: Episode? {
            didSet {
                
                guard let imageUrl = episode?.imageUrl else {return}
                episodeImageView.sd_setImage(with: URL(string: imageUrl))
                episodeName.text = episode?.title ?? ""
                episodeDescription.text = episode?.description ?? ""

    //    MARK: - Date Formatter
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM d, yyyy"
                dateFormatter.locale = Locale(identifier: "en_US")
                dateLabel.text = dateFormatter.string(from: episode?.pubDate ?? Date())

            }
        }
        

        
        
        let episodeImageView: UIImageView = {
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
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
      
        
        fileprivate func setupLayout() {
            
            
            contentView.addSubview(episodeImageView)
            episodeImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil)
            episodeImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            episodeImageView.constrainWidth(constant: 92)
            episodeImageView.constrainHeight(constant: 92)
            
            let verticalStackView = UIStackView(arrangedSubviews: [dateLabel, episodeName, episodeDescription])
                contentView.addSubview(verticalStackView)
            verticalStackView.axis = .vertical
            verticalStackView.anchor(top: episodeImageView.topAnchor, leading: episodeImageView.trailingAnchor, bottom: episodeImageView.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
            verticalStackView.distribution = .fillProportionally
        }
        
        
        
        
    }
    
    
 
    
    
    

