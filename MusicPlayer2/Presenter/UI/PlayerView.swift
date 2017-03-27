//
//  PlayerView.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/16.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import youtube_ios_player_helper

extension PlayerView {
    class Presenter: NSObject, YTPlayerViewDelegate {
        enum ViewEvents {
            case error
            case set(view: UIView)
        }
        
        let rx_viewEvent = PublishSubject<ViewEvents>()
        
        enum Events {
            case error
            case loadStarted
            case loadCompleted
            case updatedPlayTime(playTime: Float)
            case didChangeToState(state: YTPlayerState)
        }
        
        let rx_event = PublishSubject<Events>()
        let disposeBag = DisposeBag()
        let playerVars = [
            "playsinline": 1,
            "autohide": 1,
            "showinfo": 0,
            "modestbranding": 1,
            "controls": 0
        ]
        var playerView: YTPlayerView?
        var playing: Bool = false
        
        func loadContent() {
            let playerView = YTPlayerView()
            playerView.delegate = self
            rx_viewEvent.onNext(.set(view: playerView))
            self.playerView = playerView
            setupAutoPlay()
        }
        
        private func setupAutoPlay() {
//            rx_event.asDriver(onErrorJustReturn: .error).drive(onNext: { event in
//                switch event {
//                case .loadCompleted:
//                    self.play()
//                default:
//                    break
//                }
//            }).addDisposableTo(disposeBag)
        }
        
        func prepareToPlayWithYoutubeVideo(video: Movie) {
            DispatchQueue.main.async {
                let videoId = video.id
                print("[MusicPlayer]: Prepare to play(videoId: \(videoId))")
                // 再生準備処理
                self.rx_event.on(.next(.loadStarted))
                self.playerView?.load(withVideoId: videoId, playerVars: self.playerVars)
            }
        }
        
        func play() {
            DispatchQueue.main.async {
                print("[MusicPlayer]: Play")
                // 再生処理
                self.playing = true
                self.playerView?.playVideo()
            }
        }
        
        func pause() {
            DispatchQueue.main.async {
                print("[MusicPlayer]: Pause")
                // 再生処理
                self.playing = false
                self.playerView?.pauseVideo()
            }
        }
        
        func stop() {
            DispatchQueue.main.async {
                print("[MusicPlayer]: Stop")
                // 停止処理
                self.playing = false
                self.playerView?.stopVideo()
            }
        }
        
        // MARK: - YTPlayerViewDelegate
        
        @objc func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
            rx_event.on(.next(.loadCompleted))
        }
        
        @objc(playerView:didPlayTime:) func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
            rx_event.on(.next(.updatedPlayTime(playTime: playTime)))
        }
        
        @objc(playerView:didChangeToState:) func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
            rx_event.on(.next(.didChangeToState(state: state)))
        }
    }
}

class PlayerView: UIView, YTPlayerViewDelegate {
    let disposeBag = DisposeBag()
    let playerView = YTPlayerView()
    
    var presenter: Presenter? {
        didSet {
            setupSubscribe()
            presenter?.loadContent()
        }
    }
    
    private func setupSubscribe() {
        DispatchQueue.main.async {
            self.presenter?.rx_viewEvent.asDriver(onErrorJustReturn: .error).drive(onNext: { [weak self] event in
                switch event {
                case .set(let view):
                    self?.addSubview(view)
                    view.snp.makeConstraints({ make in
                        make.edges.equalTo(0)
                    })
                default:
                    break
                }
            }).addDisposableTo(self.disposeBag)
        }
    }
}
