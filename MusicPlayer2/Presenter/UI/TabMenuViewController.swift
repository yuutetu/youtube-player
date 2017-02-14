//
//  TabMenuViewController.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/13.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import UIKit
import SnapKit

class TabMenuViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    static func viewController() -> TabMenuViewController {
        return UIStoryboard(name: "TabMenuViewController", bundle: nil).instantiateInitialViewController() as! TabMenuViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewController = MusicListCollectionViewController.viewController()
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
}
