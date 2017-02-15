//
//  MusicPlayerManager.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/14.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift
import youtube_ios_player_helper
import MediaPlayer

class MusicPlayerManager : NSObject, YTPlayerViewDelegate {
    enum Events {
        case error
        case loadStarted
        case loadCompleted
        case updatedPlayType(playTime: Float)
        case didChangeToState(state: YTPlayerState)
    }
    
    let disposeBag = DisposeBag()
    let rx_event = PublishSubject<Events>()
    static let `default` = MusicPlayerManager()
    let playerView: YTPlayerView
    let playerVars = [
        "playsinline": 1,
        "autohide": 1,
        "showinfo": 0,
        "modestbranding": 1,
        "controls": 0
    ]
    var playingVideoDetail: MovieDetail?
    var playing: Bool = false
    
    override init() {
        playerView = YTPlayerView()
        super.init()
        playerView.delegate = self
    }
    
    func setup() {
        // 初期化実行用
        setupBackgroundPlay()
        setupAutoPlay()
    }
    
    func setupBackgroundPlay() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord )
        } catch  {
            fatalError("カテゴリ設定失敗")
        }
        
        do {
            try session.setActive(true)
        } catch {
            fatalError("session有効化失敗")
        }
    }
    
    func setupAutoPlay() {
        rx_event.asDriver(onErrorJustReturn: .error).drive(onNext: { event in
            switch event {
            case .loadCompleted:
                self.play()
            default:
                break
            }
        }).addDisposableTo(disposeBag)
    }
    
    func prepareToPlayWithYoutubeVideo(video: Movie) {
        guard let videoId = video.id else {
            return
        }
        
        print("[MusicPlayer]: Prepare to play(videoId: \(videoId))")
        // 再生準備処理
        rx_event.on(.next(.loadStarted))
        YoutubeAPIClient.default.request(YoutubeAPI.Movie(id: videoId)).subscribe { [weak self] (event) in
            switch event {
            case .next(let element):
                switch element.0 {
                case .success(let movies) where movies is APISingleResponse<MovieDetail>:
                    self?.playingVideoDetail = (movies as! APISingleResponse<MovieDetail>).items[0]
                    DispatchQueue.main.async {
                        self?.playerView.load(withVideoId: videoId, playerVars: self?.playerVars)
                    }
                case .success:
                    // エラー文章セット
                    self?.rx_event.on(.next(.loadCompleted))
                    break
                case .failure(let decodeError):
                    // エラー文章セット
                    print(decodeError.localizedDescription)
                    self?.rx_event.on(.next(.loadCompleted))
                    break
                }
            case .completed:
                break
            case .error(let error):
                self?.playingVideoDetail = nil
                // エラー文章セット
                self?.rx_event.on(.next(.loadCompleted))
                print(error)
            }
            }.addDisposableTo(disposeBag)
    }
    
    func play() {
        print("[MusicPlayer]: Play")
        // 再生処理
        playing = true
        playerView.playVideo()
    }
    
    func pause() {
        print("[MusicPlayer]: Pause")
        // 再生処理
        playing = false
        playerView.pauseVideo()
    }
    
    func stop() {
        print("[MusicPlayer]: Stop")
        // 停止処理
        playing = false
        playerView.stopVideo()
    }
    
    // MARK: - YTPlayerViewDelegate
    
    @objc func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        rx_event.on(.next(.loadCompleted))
    }
    
    @objc(playerView:didPlayTime:) func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        rx_event.on(.next(.updatedPlayType(playTime: playTime)))
    }
    
    @objc(playerView:didChangeToState:) func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        rx_event.on(.next(.didChangeToState(state: state)))
    }
}
