//
//  BaseContainerViewController.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/04/16.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import UIKit
import SnapKit

class BaseContainerViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContents()
    }
    
    func setupContents() {
        let viewController = YoutubeTableViewController.viewController()
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.snp_makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
}
