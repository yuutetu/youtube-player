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
        let mainScheduler: SerialDispatchQueueScheduler = MainScheduler.instance
        YoutubeApiClient.defaultClient.request(YoutubeAPI.Movies.Popular).observeOn(mainScheduler).subscribe({ event in
            switch event {
            case .Next(let element):
                do {
                    guard let json = try NSJSONSerialization.JSONObjectWithData(element.0, options: NSJSONReadingOptions()) as? [String: AnyObject] else {
                        print("error: 1")
                        return
                    }
                    print(json)
                    // TODO: パースしてセルを生成
                    // TODO: セルの追加とセル数計算の更新
                } catch _ {
                    print("error: 2")
                }
            case .Completed:
                break
            case .Error(let error):
                print(error)
            }
        }).addDisposableTo(disposeBag)
    }
}
