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
    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    
    static func viewController() -> MusicListCollectionViewController {
        return UIStoryboard(name: "MusicListCollectionViewController", bundle: nil).instantiateInitialViewController() as! MusicListCollectionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Variable(["a", "b", "c"]).asDriver().drive(collectionView.rx.items(cellIdentifier: "ItemCell")) {
            (index: Int, model: String, cell: UICollectionViewCell) -> Void in
            (cell as! MusicItemCollectionViewCell).titleLabel.text = model
        }.addDisposableTo(disposeBag)
        
        collectionView.rx.delegate.setForwardToDelegate(self, retainDelegate: false)
    }
}

extension MusicListCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: presenterに伝える
    }
}

extension MusicListCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
}
