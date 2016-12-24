//
//  PlayerContainerViewController.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2016/12/23.
//  Copyright © 2016年 Masayuki Kagae. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PlayerPresenter {
    var displayingPlayerView: Variable<Bool> {
        return Variable(true)
    }
}

class PlayerContainerViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playerView: UIView!
    
    var presenter: PlayerPresenter?
    var isPlaying: Bool = false
    let disposeBag = DisposeBag()
    
    static func viewController() -> PlayerContainerViewController {
        return UIStoryboard(name: "PlayerContainerViewController", bundle: nil).instantiateInitialViewController() as! PlayerContainerViewController
    }
    
    func inject(presenter: PlayerPresenter) {
        self.presenter = presenter
        
        _ = view // Load view
        presenter.displayingPlayerView.asDriver()
            .map{ !$0 }.drive(playerView.rx.isHidden)
            .addDisposableTo(disposeBag)
    }

    // TODO: Containerの設定
}
