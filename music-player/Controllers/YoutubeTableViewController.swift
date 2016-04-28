//
//  YoutubeTableViewController.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/04/16.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import UIKit
import RxSwift

class YoutubeTableViewController: UITableViewController {
    let disposeBag = DisposeBag()
    
    static func viewController() -> YoutubeTableViewController {
        return YoutubeTableViewController(style: .Plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContents()
    }
    
    func setupContents() {
        // TODO: DataSourceとViewModelの構成にしたい
        YoutubeApiClient.defaultClient.request().subscribe({ event in
            switch event {
            case .Next(let element):
                print(element.0.description)
                // TODO: パースしてセルを生成
                // TODO: セルの追加とセル数計算の更新
            case .Completed:
                break
            case .Error(let error):
                print(error)
            }
        }).addDisposableTo(disposeBag)
    }
}
