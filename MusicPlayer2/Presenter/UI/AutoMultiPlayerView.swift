//
//  AutoMultiPlayerView.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/15.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import UIKit
import RxSwift

extension AutoMultiPlayerView {
    class Presenter {
        enum Events {
            case error
            case add(view: UIView)
        }
        
        let rx_event = PublishSubject<Events>()
        
        func loadContent() {
            let playerView = MusicPlayerManager.default.playerView
            rx_event.onNext(.add(view: playerView))
        }
        
        func prepareToPlay(dataSource: APIDataSource<Movie>, index: Int) {
            MusicPlayerManager.default.prepareToPlayWithYoutubeVideo(video: dataSource[index])
        }
        
        func play() {
            print("[AutoMultiPlayerView]: Play")
            MusicPlayerManager.default.play()
        }
        
        func pause() {
            print("[AutoMultiPlayerView]: Pause")
            MusicPlayerManager.default.pause()
        }
        
        func stop() {
            print("[AutoMultiPlayerView]: Stop")
            MusicPlayerManager.default.stop()
        }
    }
}

class AutoMultiPlayerView: UIView {
    let disposeBag = DisposeBag()
    
    var presenter: Presenter? {
        didSet {
            setupSubscribe()
            presenter?.loadContent()
        }
    }
    
    private func setupSubscribe() {
        presenter?.rx_event.asDriver(onErrorJustReturn: .error).drive(onNext: { [weak self] event in
            guard let `self` = self else {
                return
            }
            
            switch event {
            case .add(let view):
                self.addSubview(view)
                view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(0)
                })
            case .error:
                break
            }
        }).addDisposableTo(disposeBag)
    }
}
