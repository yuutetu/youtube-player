//
//  SearchViewController.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/17.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTextField: UISearchBar!
    
    static func viewController() -> SearchViewController {
        return UIStoryboard(name: "SearchViewController", bundle: nil).instantiateInitialViewController() as! SearchViewController
    }
}
