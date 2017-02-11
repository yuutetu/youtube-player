//
//  RootViewController.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2016/12/23.
//  Copyright © 2016年 Masayuki Kagae. All rights reserved.
//

import UIKit
import SnapKit

class RootViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presenter = PlayerPresenter()
        let viewController = PlayerContainerViewController.viewController()
        viewController.inject(presenter: presenter)
        containerView.addSubview(viewController.view)
        addChildViewController(viewController)
        viewController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

