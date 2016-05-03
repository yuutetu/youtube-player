//
//  MyPlayListTableViewController.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/05/03.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MyPlayListTableViewController: UIViewController, UITableViewDelegate {
    var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    private(set) var playLists: Variable<[String]> = {
        let initialPlayLists = Variable<[String]>([])
        initialPlayLists.value.append("東方")
        initialPlayLists.value.append("Diva X")
        return initialPlayLists
    }()
    
    static func viewController() -> MyPlayListTableViewController {
        return MyPlayListTableViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "マイリスト"
        setupTableView()
        setupContents()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: .zero)
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    func setupContents() {
        playLists.asDriver().drive(tableView.rx_itemsWithCellFactory) { (tableView, index, playList) in
            let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: NSIndexPath(forRow: index, inSection: 0))
            cell.textLabel?.text = playList
            return cell
        }.addDisposableTo(disposeBag)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "BasicCell")
        
        tableView.rx_delegate.setForwardToDelegate(self, retainDelegate: false)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = MyPlayListTableViewController.viewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
