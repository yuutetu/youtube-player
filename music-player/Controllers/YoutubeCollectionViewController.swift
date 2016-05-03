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
import Haneke

class YoutubeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
}

class YoutubeCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    private(set) var moviesVariable: Variable<[Movie]> = Variable([Movie]())
    private(set) var dataSource: APIDataSource<Movie>?
    
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
        let dataSource = APIDataSource<Movie>(request: YoutubeAPI.Movies.Search(query: "東方 bgm".escapeStr()))
        dataSource.models.asDriver().drive(collectionView.rx_itemsWithCellFactory) { (collectionView, index, movie) in
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            if index == collectionView.numberOfItemsInSection(0) - 5 {
                self.dataSource?.next()
            }
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BasicCell", forIndexPath: indexPath) as! YoutubeCollectionViewCell
            cell.titleLabel?.text = movie.snippet.title
            cell.thumbnailImageView?.hnk_setImageFromURL(movie.snippet.thumbnailURL)
            return cell as UICollectionViewCell
        }.addDisposableTo(disposeBag)
        
        collectionView.rx_delegate.setForwardToDelegate(self, retainDelegate: false)
        
        dataSource.load()
        self.dataSource = dataSource
    }
}

extension YoutubeCollectionViewController: UICollectionViewDelegate {
    
}

extension YoutubeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
}