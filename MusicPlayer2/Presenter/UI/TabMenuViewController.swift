//
//  TabMenuViewController.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/13.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

extension TabMenuViewController {
    class Presenter {
        enum ViewEvents {
            case error
            case set(rightButton: UIBarButtonItem)
            case push(viewController: UIViewController)
        }
        
        let rx_viewEvent = PublishSubject<ViewEvents>()
        
        func loadContent() {
//            let button = UIButton(type: .custom)
//            button.setImage(#imageLiteral(resourceName: "icon-search"), for: .normal)
//            button.addTarget(self, action: #selector(handleSearchButtonTapped), for: .touchUpInside)
//            let rightButton = UIBarButtonItem(customView: button)
//            let rightButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchButtonTapped))
//            rx_viewEvent.onNext(.set(rightButton: rightButton))
        }
        
//        @objc func handleSearchButtonTapped() {
//            let searchViewController = SearchViewController.viewController()
//            rx_viewEvent.onNext(.push(viewController: searchViewController))
//        }
    }
}

class TabMenuViewController: UINavigationController {
    @IBOutlet weak var containerView: UIView!
    let disposeBag = DisposeBag()
    var presenter: Presenter? {
        didSet {
            setupSubscribe()
            presenter?.loadContent()
        }
    }
    
    static func viewController() -> TabMenuViewController {
        let rootViewController = MusicListCollectionViewController.viewController()
        let viewController = TabMenuViewController(rootViewController: rootViewController)
        let tabMenuPresenter = TabMenuViewController.Presenter()
        viewController.presenter = tabMenuPresenter
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setupSubscribe() {
//        presenter?.rx_viewEvent.asDriver(onErrorJustReturn: .error).drive(onNext: { [weak self] event in
//            switch event {
//            case .set(let rightButton):
//                self?.navigationItem.rightBarButtonItem = rightButton
//            default:
//                break
//            }
//        }).addDisposableTo(disposeBag)
    }
    
    @objc func handleSearchButtonTapped() {
        let searchViewController = SearchViewController.viewController()
//        rx_viewEvent.onNext(.push(viewController: searchViewController))
        pushViewController(searchViewController, animated: true)
    }
}
