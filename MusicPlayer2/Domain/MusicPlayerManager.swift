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

protocol Player: class {
    func prepareToPlay(dataSource: APIDataSource<Movie>, index: Int)
    func play()
    func pause()
    func stop()
}

class MusicPlayerManager : NSObject, YTPlayerViewDelegate {
    static let `default` = MusicPlayerManager()
    
    weak var player: Player?
    
    func setup() {
        // 初期化実行用
        setupBackgroundPlay()
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
    
    func prepareToPlay(dataSource: APIDataSource<Movie>, index: Int) {
        player?.prepareToPlay(dataSource: dataSource, index: index)
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.stop()
    }
}
