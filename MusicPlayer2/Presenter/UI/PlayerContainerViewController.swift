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
    @IBOutlet weak var movieView: UIView!
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var stopImageView: UIImageView!
    @IBOutlet weak var nextImageView: UIImageView!
    
    @IBOutlet weak var titleView: UIView!
    
    var titleLabel: UILabel?
    
    var presenter: PlayerPresenter?
    var isPlaying: Bool = false
    let disposeBag = DisposeBag()
    var autoPlayerPresenter: AutoMultiPlayerView.Presenter?
    
    static func viewController() -> PlayerContainerViewController {
        return UIStoryboard(name: "PlayerContainerViewController", bundle: nil).instantiateInitialViewController() as! PlayerContainerViewController
    }
    
    func inject(presenter: PlayerPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlayerView()
        
        presenter?.displayingPlayerView.asDriver()
            .map{ !$0 }.drive(playerView.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        let viewController = TabMenuViewController.viewController()
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }

    // TODO: Containerの設定
    
    func setupPlayerView() {
        let playerPresenter = AutoMultiPlayerView.Presenter()
        let playerView = AutoMultiPlayerView(frame: CGRect.zero)
        playerView.presenter = playerPresenter
        movieView.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        autoPlayerPresenter = playerPresenter
        
        let previousImage = #imageLiteral(resourceName: "icon-previous")
        previousImage.withRenderingMode(.alwaysTemplate)
        previewImageView.image = previousImage
        previewImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7)
        
        let playImage = #imageLiteral(resourceName: "icon-play")
        playImage.withRenderingMode(.alwaysTemplate)
        playImageView.image = playImage
        playImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7)
        
        let stopImage = #imageLiteral(resourceName: "icon-stop")
        stopImage.withRenderingMode(.alwaysTemplate)
        stopImageView.image = stopImage
        stopImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7)
        
        let nextImage = #imageLiteral(resourceName: "icon-next")
        nextImage.withRenderingMode(.alwaysTemplate)
        nextImageView.image = nextImage
        nextImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7)
        
        let gradientMaskLayer:CAGradientLayer = CAGradientLayer()
        gradientMaskLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientMaskLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientMaskLayer.frame = titleView.bounds
        gradientMaskLayer.colors = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor]
        gradientMaskLayer.locations = [0.0, 0.2, 0.8, 1.0]
        titleView.layer.mask = gradientMaskLayer
        
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        let label = UILabel(frame: CGRect.zero)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.text = "【100分耐久】doll【東方自然癒】"
        let fitSize = label.sizeThatFits(titleView.bounds.size)
        label.frame = CGRect(
            x: titleView.bounds.width,
            y: (titleView.bounds.height - fitSize.height) / 2,
            width: fitSize.width,
            height: fitSize.height
        )
        titleLabel = label
        titleView.addSubview(label)
        
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(titleUpdate(timer:)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func titleUpdate(timer: Timer) {
        guard let titleLabel = titleLabel else {
            return
        }
        
        let frame = titleLabel.frame
        let x = titleLabel.frame.minX - 1
        print(x < -frame.width ? frame.width : x)
        titleLabel.frame = CGRect(
            x: x < -frame.width ? titleView.frame.width : x,
            y: frame.minY,
            width: frame.width,
            height: frame.height
        )
    }
    
    @IBAction func handleStart() {
//        MusicPlayerManager.default.play()
        autoPlayerPresenter?.play()
    }
    
    @IBAction func handleStop() {
//        MusicPlayerManager.default.stop()
        autoPlayerPresenter?.stop()
    }
    
    @IBAction func handleNext() {
        
    }
    
    @IBAction func handlePrevious() {
        
    }
}
