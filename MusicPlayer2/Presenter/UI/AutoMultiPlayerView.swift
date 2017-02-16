//
//  AutoMultiPlayerView.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/15.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import UIKit
import RxSwift

private let previousPreloadCount: Int = 0
private let nextPreloadCount: Int = 0

extension AutoMultiPlayerView {
    class Presenter: Player {
        enum Events {
            case error
            case add(view: UIView)
            case remove(view: UIView)
        }
        
        let disposeBag = DisposeBag()
        let rx_event = PublishSubject<Events>()
        var playerViewForMovieID: [String: PlayerView] = [:]
        var movieIDForPlayerView: [PlayerView: String] = [:]
        var currentDataSource: APIDataSource<Movie>?
        var currentIndex: Int?
        var currentPlayerMode: PlayerMode = .intro
        
        func loadContent() {
//            let playerPresenter = PlayerView.Presenter()
//            let playerView = PlayerView()
//            playerView.presenter = playerPresenter
//            rx_event.onNext(.add(view: playerView))
//            self.playerPresenter = playerPresenter
        }
        
        private func prepareToPlay(dataSource: APIDataSource<Movie>, index: Int) {
            self.currentDataSource = dataSource
            self.currentIndex = index
            
            let movies = ((index - previousPreloadCount)...(index + nextPreloadCount)).map({ index -> Movie? in
                dataSource.itemAtIndex(index: index)
            }).filter { $0 != nil }.map { $0! }
            
            // 不要なviewを削除
            let removeMovieIDs = Set(playerViewForMovieID.keys).subtracting(movies.map({ $0.id }).filter { $0 != nil }.map { $0! })
            for removeMovieID in removeMovieIDs {
                guard let playerView = playerViewForMovieID[removeMovieID] else {
                    continue
                }
                
                rx_event.onNext(.remove(view: playerView))
                playerViewForMovieID.removeValue(forKey: removeMovieID)
                movieIDForPlayerView.removeValue(forKey: playerView)
            }
            
            for movie in movies {
                let movieID = movie.id
//                guard let movieID = movie.id else {
//                    continue
//                }
                
                setupIfNeeded(movieID)
                
                guard let playerView = playerViewForMovieID[movieID] else {
                    continue
                }
                
                playerView.presenter?.prepareToPlayWithYoutubeVideo(video: movie)
            }
        }
        
        private func setupIfNeeded(_ movieID: String) {
            guard playerViewForMovieID[movieID] == nil else {
                return
            }
            
            let playerViewPresenter = PlayerView.Presenter()
            let playerView = PlayerView(frame: CGRect.zero)
            playerView.presenter = playerViewPresenter
            rx_event.onNext(.add(view: playerView))
            playerViewForMovieID[movieID] = playerView
            movieIDForPlayerView[playerView] = movieID
            playerViewPresenter.rx_event.subscribe(onNext: { [weak self] event in
                guard let `self` = self else {
                    return
                }
                
                switch event {
                case .loadCompleted:
                    guard
                        let index = self.currentIndex,
                        let currentMovieID = self.currentDataSource?[index].id,
                        movieID == currentMovieID else {
                        break
                    }
                    
                    self.playerViewForMovieID[currentMovieID]?.presenter?.play()
                case .updatedPlayTime(let playTime):
                    if self.currentPlayerMode == .intro && playTime > 15 {
                        guard
                            let index = self.currentIndex,
                            let currentMovieID = self.currentDataSource?[index].id,
                            movieID == currentMovieID else {
                                break
                        }
                        
                        self.next()
                    }
                case .didChangeToState(let state):
                    switch state {
                    case .ended:
                        guard let index = self.currentIndex,
                            let currentMovieID = self.currentDataSource?[index].id,
                            movieID == currentMovieID else {
                                break
                        }
                        
                        self.next()
                    default:
                        break
                    }
                default:
                    break
                }
            }).addDisposableTo(disposeBag)
        }
        
        func play(dataSource: APIDataSource<Movie>, index: Int) {
            print("[AutoMultiPlayerView]: Play")
            prepareToPlay(dataSource: dataSource, index: index)
        }
        
        func play() {
            guard let index = currentIndex,
                let dataSource = currentDataSource else {
                    return
            }
            
            play(dataSource: dataSource, index: index)
        }
        
        func next() {
            guard let index = currentIndex,
                let dataSource = currentDataSource else {
                    return
            }
            
            print("[AutoMultiPlayerView]: Next")
            prepareToPlay(dataSource: dataSource, index: index + 1)
        }
        
        func previous() {
            guard let index = currentIndex,
                let dataSource = currentDataSource else {
                    return
            }
            
            print("[AutoMultiPlayerView]: Next")
            prepareToPlay(dataSource: dataSource, index: index - 1)
        }
        
        func pause() {
            guard let index = currentIndex,
                let dataSource = currentDataSource,
                let playerView = playerViewForMovieID[dataSource[index].id] else {
                    return
            }
            
            print("[AutoMultiPlayerView]: Pause")
            playerView.presenter?.pause()
        }
        
        func stop() {
            guard let index = currentIndex,
                let dataSource = currentDataSource,
                let playerView = playerViewForMovieID[dataSource[index].id] else {
                    return
            }
            
            print("[AutoMultiPlayerView]: Stop")
            playerView.presenter?.stop()
        }
        
        func set(playerMode: PlayerMode) {
            currentPlayerMode = playerMode
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
            case .remove(let view):
                view.removeFromSuperview()
            case .error:
                break
            }
        }).addDisposableTo(disposeBag)
    }
}
