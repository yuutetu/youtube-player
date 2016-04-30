//
//  YoutubeTableViewController.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/04/16.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class YoutubeTableViewController: UITableViewController {
    let disposeBag = DisposeBag()
    private(set) var moviesVariable: Variable<[Movie]> = Variable([Movie]())
    
    static func viewController() -> YoutubeTableViewController {
        return YoutubeTableViewController(style: .Plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContents()
    }
    
    func setupContents() {
        // TODO: DataSourceとViewModelの構成にしたい
        
        // 読み込み処理
        let mainScheduler: SerialDispatchQueueScheduler = MainScheduler.instance
        YoutubeApiClient.defaultClient.request(YoutubeAPI.Movies.Popular).observeOn(mainScheduler).subscribe({ event in
            switch event {
            case .Next(let element):
                // 一覧データセット
                switch element.0 {
                case .Success(let movies):
                    self.moviesVariable.value = (movies as! APIMultipleResponse<Movie>).items
                case .Failure:
                    self.moviesVariable.value = []
                    // エラー文章セット
                    break
                }
            case .Completed:
                // isLoading = false
                break
            case .Error(let error):
                self.moviesVariable.value = []
                // エラー文章セット
                // isLoading = false
                print(error)
            }
        }).addDisposableTo(disposeBag)
        
        // TableViewへの挿入処理
        moviesVariable.asDriver().drive(tableView.rx_itemsWithCellIdentifier("BasicCell")) { (_, movie: Movie, cell: UITableViewCell) -> Void in
            cell.textLabel?.text = movie.snippet.title
        }.addDisposableTo(disposeBag)
        
        // cellの初期設定
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "BasicCell")
    }
}
