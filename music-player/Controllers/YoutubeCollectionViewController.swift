//
//  YoutubeCollectionViewController.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/04/30.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class YoutubeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class YoutubeCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    private(set) var moviesVariable: Variable<[Movie]> = Variable([Movie]())
    
    static func viewController() -> YoutubeCollectionViewController {
        return UIStoryboard(name: "YoutubeCollectionViewController", bundle: nil).instantiateInitialViewController() as! YoutubeCollectionViewController
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
        
        // CollectionViewへの挿入処理
        moviesVariable.asDriver().drive(collectionView.rx_itemsWithCellIdentifier("BasicCell")) { (_, movie: Movie, cell: YoutubeCollectionViewCell) -> Void in
            cell.titleLabel?.text = movie.snippet.title
        }.addDisposableTo(disposeBag)
//
//        
//        moviesVariable.asDriver().drive(collectionView.rx_itemsWithCellIdentifier("BasicCell")) { (_, movie: Movie, cell: UICollectionViewCell) -> Void in
//            cell.textLabel?.text = movie.snippet.title
//        }.addDisposableTo(disposeBag)
    }
}