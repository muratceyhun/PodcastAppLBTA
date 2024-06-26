//
//  PodcastPlayerView.swift
//  PodcastAppLBTA
//
//  Created by Murat Ceyhun Korpeoglu on 20.03.2024.
//

import UIKit
import FeedKit
import AVKit



class PodcastPlayerView: UIView {
        
    var episode: Episode? {
        didSet {
            
            imageView.sd_setImage(with: URL(string: episode?.imageUrl ?? ""))
            miniUIImageView.sd_setImage(with: URL(string: episode?.imageUrl ?? ""))

            imageView.layer.cornerRadius = 24
            episodeName.text = episode?.title
            miniEpisodeName.text = episode?.title
            artistName.text = episode?.artistName
            playEpisode()
            shrinkImageView()
        }
    }
    
    fileprivate func playEpisode() {
        
        if episode?.fileUrl != nil {
            playEpisodeUsingFilewURL()
        } else {
            print("Episode is playing at", episode?.streamUrl ?? "")
            
            guard let url = URL(string: episode?.streamUrl ?? "") else {return}
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
        }
        
    }
    
    fileprivate func playEpisodeUsingFilewURL() {
        print("Attempt to play with fileUrl:", episode?.fileUrl ?? "")
        
        guard let fileURL = URL(string: episode?.fileUrl ?? "") else {return}
        let fileName = fileURL.lastPathComponent
        guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        
        trueLocation.appendPathComponent(fileName, conformingTo: .fileURL)
        print("**")
        print(trueLocation.absoluteString)
        
        
//            guard let url = URL(string: episode?.fileUrl ?? "") else {return}
        let playerItem = AVPlayerItem(url: trueLocation)
        player.replaceCurrentItem(with: playerItem)
    }
    
    
    deinit {
        print("Deinitialized")
    }
    
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()

    
    
    let imageView: UIImageView = {
        let iw = UIImageView()
        iw.clipsToBounds = true
        return iw
    }()
    
    lazy var timeSlider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(handleTimeSlider), for: .valueChanged)
        return slider
    }()
    
    
    @objc func handleTimeSlider() {
        
        let percentage = timeSlider.value
        
        guard let duration = player.currentItem?.duration else {return}
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
        
        
        
    }
    
    let time1: UILabel = {
        let name = UILabel()
        name.text = "00:00"
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
    
    
    let episodeName: UILabel = {
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
    
    lazy var backwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gobackward.15"), for: .normal)
        button.addTarget(self, action: #selector(handleGoBack15), for: .touchUpInside)
        return button
    }()
    
    @objc func handleGoBack15() {
        
        goOrBackFitteen(-15)
        
    }
    
    fileprivate func goOrBackFitteen(_ sec: Int64) {
        let currentTime = player.currentTime()
        let fifteenSec = CMTimeMake(value: sec, timescale: 1)
        let seekTime = CMTimeAdd(currentTime, fifteenSec)
        player.seek(to: seekTime)
    }
        
    lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlayPause() {
        print("Play/Pause")
        
        if player.timeControlStatus == .playing {
            
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            shrinkImageView()
        } else {
            player.play()
            episodeTime()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            enlargeImageView()
        }
    }
    
    fileprivate func episodeTime() {
        
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.time1.text = time.toDisplayString()
            self?.updateTimeSlider()
            self?.toShowFinishEpisode()

        }

        guard let durationTime = player.currentItem?.duration else {return}
        time2.text = durationTime.toDisplayString()
        
    }
    
    fileprivate func toShowFinishEpisode() {
        
        if time1.text == time2.text {
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        
    }
    
    fileprivate func updateTimeSlider() {
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime())
        let percentage = currentTime / duration

        timeSlider.minimumValue = 0
        timeSlider.maximumValue = 1
        timeSlider.value = Float(percentage)
    
    }
    
    
    fileprivate func shrinkImageView() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7) {
            self.imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
        
    }
    
    fileprivate func enlargeImageView() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7) {
            self.imageView.transform = .identity
        }
    }
    

    lazy var forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "goforward.15"), for: .normal)
        button.addTarget(self, action: #selector(handleGo15), for: .touchUpInside)
        return button
    }()
    
    @objc func handleGo15() {
        
        goOrBackFitteen(15)
        
    }
    
    lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(handleVolume), for: .valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.5
        return slider
    }()
    
    @objc func handleVolume() {
    
        player.volume = volumeSlider.value
        
    }
    
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
        
        
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        
        let tabBarController = keyWindow?.rootViewController as? BaseTabBarController
        tabBarController?.minimizeFloatView()
        print("Close Button Clicked")
        
    }
    
    let miniUIImageView: UIImageView = {
        let iw = UIImageView()
        iw.backgroundColor = .green
        iw.layer.cornerRadius = 8
        iw.clipsToBounds = true
        iw.constrainHeight(constant: 64)
        iw.constrainWidth(constant: 64)
        return iw
    }()
    
    
    let miniEpisodeName: UILabel = {
        let name = UILabel()
        name.text = "Episode Name"
        name.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        name.numberOfLines = 1
        name.textAlignment = .left
        name.constrainWidth(constant: 160)
        name.constrainHeight(constant: 80)
        return name
    }()
    
    lazy var miniPlayPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.constrainHeight(constant: 58)
        button.constrainWidth(constant: 58)
        button.addTarget(self, action: #selector(miniHandlePlayPause), for: .touchUpInside)
        return button
    }()
    
    
    @objc func miniHandlePlayPause() {
        print("Play/Pause")
        
        if player.timeControlStatus == .playing {
            
            player.pause()
            miniPlayPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            episodeTime()
            miniPlayPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    lazy var miniForwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "goforward.15"), for: .normal)
        button.constrainHeight(constant: 58)
        button.constrainWidth(constant: 58)
        button.addTarget(self, action: #selector(handleGo15), for: .touchUpInside)
        return button
    }()
    
    
    let miniPlayerView = UIView()

    
    
    fileprivate func setupMiniPlayerView() {
        
        addSubview(miniPlayerView)
        miniPlayerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor(white: 0.6, alpha: 0.7)
        miniPlayerView.addSubview(separatorLine)

        separatorLine.anchor(top: miniPlayerView.topAnchor, leading: miniPlayerView.leadingAnchor, bottom: nil, trailing: miniPlayerView.trailingAnchor)
        separatorLine.constrainHeight(constant: 0.3)
        let stackView = UIStackView(arrangedSubviews: [miniUIImageView, miniEpisodeName, miniPlayPauseButton, miniForwardButton])
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        miniPlayerView.addSubview(stackView)
        stackView.anchor(top: miniPlayerView.topAnchor, leading: miniPlayerView.leadingAnchor, bottom: miniPlayerView.bottomAnchor, trailing: miniPlayerView.trailingAnchor, padding: .init(top: 4, left: 12, bottom: 4, right: 0))
        miniPlayerView.constrainHeight(constant: 88)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupMiniPlayerView()
    
        addSubview(imageView)
        imageView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 30, left: 30, bottom: 0, right: 30))
        imageView.constrainHeight(constant: 320)
        
        addSubview(timeSlider)
        timeSlider.anchor(top: imageView.bottomAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: imageView.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        addSubview(time1)
        time1.anchor(top: timeSlider.bottomAnchor, leading: timeSlider.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
        addSubview(time2)
        time2.anchor(top: timeSlider.bottomAnchor, leading: nil, bottom: nil, trailing: timeSlider.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
        addSubview(episodeName)
        episodeName.anchor(top: timeSlider.bottomAnchor, leading: timeSlider.leadingAnchor, bottom: nil, trailing: timeSlider.trailingAnchor, padding: .init(top: 48, left: 0, bottom: 0, right: 0))
        
        addSubview(artistName)
        artistName.anchor(top: episodeName.bottomAnchor, leading: timeSlider.leadingAnchor, bottom: nil, trailing: timeSlider.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))

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
