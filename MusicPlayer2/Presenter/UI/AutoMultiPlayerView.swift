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
    class Presenter: Player {
        enum Events {
            case error
            case add(view: UIView)
        }
        
        let rx_event = PublishSubject<Events>()
        var playerPresenter: PlayerView.Presenter?
        
        func loadContent() {
            let playerPresenter = PlayerView.Presenter()
            let playerView = PlayerView()
            playerView.presenter = playerPresenter
            rx_event.onNext(.add(view: playerView))
            self.playerPresenter = playerPresenter
        }
        
        func prepareToPlay(dataSource: APIDataSource<Movie>, index: Int) {
            playerPresenter?.prepareToPlayWithYoutubeVideo(video: dataSource[index])
        }
        
        func play() {
            print("[AutoMultiPlayerView]: Play")
            playerPresenter?.play()
        }
        
        func pause() {
            print("[AutoMultiPlayerView]: Pause")
            playerPresenter?.pause()
        }
        
        func stop() {
            print("[AutoMultiPlayerView]: Stop")
            playerPresenter?.stop()
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
