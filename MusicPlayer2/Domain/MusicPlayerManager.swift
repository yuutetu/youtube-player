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

enum PlayerMode {
    case intro
    case full
}

protocol Player: class {
    func play(dataSource: APIDataSource<Movie>, index: Int)
    func play()
    func next()
    func previous()
    func pause()
    func stop()
    func set(playerMode: PlayerMode)
}

class MusicPlayerManager : NSObject, YTPlayerViewDelegate {
    static let `default` = MusicPlayerManager()
    
    weak var player: Player?
    
    func setup() {
        // 初期化実行用
        setupBackgroundPlay()
        setupControlCenter()
    }
    
    private func setupBackgroundPlay() {
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
    
    private func setupControlCenter() {
        let center = MPRemoteCommandCenter.shared()
        let nextCommand = center.nextTrackCommand
        nextCommand.isEnabled = true
        nextCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.next()
            return .success
        }
        let previousCommand = center.previousTrackCommand
        previousCommand.isEnabled = true
        previousCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.previous()
            return .success
        }
        
    }
    
    func play(dataSource: APIDataSource<Movie>, index: Int) {
        player?.play(dataSource: dataSource, index: index)
    }
    
    func play() {
        player?.play()
    }
    
    func next() {
        player?.next()
    }
    
    func previous() {
        player?.previous()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.stop()
    }
    
    func set(playerMode: PlayerMode) {
        player?.set(playerMode: playerMode)
    }
}
