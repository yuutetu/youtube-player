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
import SnapKit

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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.displayingPlayerView.asDriver()
            .map{ !$0 }.drive(playerView.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        let viewController = MusicListCollectionViewController.viewController()
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }

    // TODO: Containerの設定
}
