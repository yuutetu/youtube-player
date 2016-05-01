//
//  UICollectionView+Rx.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/05/01.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//class ReCollectionViewDelegateProxy: DelegateProxy, UICollectionViewDelegate, DelegateProxyType {
//    class func currentDelegateFor(object: AnyObject) -> AnyObject? {
//        guard let maybeResult = object as? UICollectionView else {
//             fatalError("Failure converting from \(object) to \(UICollectionView.self)")
//        }
//        return maybeResult.delegate
//    }
//    
//    class func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
//        guard let collectionView = object as? UICollectionView else {
//            fatalError("Failure converting from \(object) to \(UICollectionView.self)")
//        }
//        
//        guard let delegate = delegate else {
//            collectionView.delegate = nil
//            return
//        }
//        
//        guard let collectionViewDelegate = delegate as? UICollectionViewDelegate else {
//            fatalError("Failure converting from \(delegate) to \(UICollectionViewDelegate.self)")
//        }
//
//        collectionView.delegate = collectionViewDelegate
//    }
//}

//extension UICollectionView {
//    public var rx_delegate: DelegateProxy {
//        return proxyForObject(ReCollectionViewDelegateProxy.self, self)
//    }
//}
