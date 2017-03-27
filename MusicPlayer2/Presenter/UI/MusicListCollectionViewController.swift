//
//  MusicListCollectionViewController.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2016/12/24.
//  Copyright © 2016年 Masayuki Kagae. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MusicListCollectionViewController: UIViewController {
    @IBOutlet weak var listView: UICollectionView!
    let disposeBag = DisposeBag()
    let values = Variable(["a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c"])
    private(set) var dataSource: APIDataSource<Movie>?
    
    static func viewController() -> MusicListCollectionViewController {
        return UIStoryboard(name: "MusicListCollectionViewController", bundle: nil).instantiateInitialViewController() as! MusicListCollectionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = APIDataSource<Movie>(request: YoutubeAPI.Movies.Search(query: "pso2 bgm"))
        
        dataSource?.models.asDriver().drive(listView.rx.items(cellIdentifier: "ItemCell", cellType: MusicItemCollectionViewCell.self)) { [weak self]
            (index: Int, model: Movie, cell: MusicItemCollectionViewCell) -> Void in
            guard let `self` = self else {
                return
            }
            
            if index == self.listView.numberOfItems(inSection: 0) - 1 {
                self.dataSource?.next()
            }
            cell.setup(with: model)
        }.addDisposableTo(disposeBag)
        
        
        listView.rx.delegate.setForwardToDelegate(self, retainDelegate: false)
        
        dataSource?.load(loaded: { [dataSource = self.dataSource] in
            guard let dataSource = dataSource else {
                return
            }
            
            MusicPlayerManager.default.play(dataSource: dataSource, index: 0)
        })
    }
}

extension MusicListCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = dataSource else {
            return
        }
        
        MusicPlayerManager.default.play(dataSource: dataSource, index: indexPath.row)
    }
}

extension MusicListCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
