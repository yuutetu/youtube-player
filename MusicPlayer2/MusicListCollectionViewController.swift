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
    let values = Variable(["a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c"])
    
    static func viewController() -> MusicListCollectionViewController {
        return UIStoryboard(name: "MusicListCollectionViewController", bundle: nil).instantiateInitialViewController() as! MusicListCollectionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        values.asDriver().drive(collectionView.rx.items(cellIdentifier: "ItemCell", cellType: MusicItemCollectionViewCell.self)) {
            (index: Int, model: String, cell: MusicItemCollectionViewCell) -> Void in
            cell.titleLabel.text = model
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
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
