//
//  MusicPlayerManager.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/14.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class MusicPlayerManager {
    let disposeBag = DisposeBag()
    var musicWebView: UIWebView = UIWebView(frame: CGRect.zero)
    weak var musicView: UIView? {
        didSet {
            guard let musicView = musicView else {
                return
            }
            
            setup(musicView)
        }
    }
    static var `default`: MusicPlayerManager = MusicPlayerManager()
    
    private init() {
        
    }
    
    private func setup(_ musicView: UIView) {
        for subview in musicView.subviews {
            subview.removeFromSuperview()
        }
        
        musicView.addSubview(musicWebView)
        musicWebView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    func prepareForPlay(dataSource: APIDataSource<Movie>, index: Int) {
        let movie = dataSource[index]
        guard let movieId = movie.id else {
            return
        }
        
        YoutubeAPIClient.default.request(YoutubeAPI.Movie(id: movieId)).subscribe(onNext: { [weak self] (result: Result<APISerializationValue>, response: HTTPURLResponse) in
            switch result {
            case .success(let response) where response is APISingleResponse<MusicPlayer2.MovieDetail>:
                DispatchQueue.main.async {
                    self?.musicWebView.loadHTMLString((response as! APISingleResponse<MusicPlayer2.MovieDetail>).items[0].embedHtml, baseURL: nil)
                }
            case .success:
                break
            case .failure:
                break
            }
        }).addDisposableTo(disposeBag)
    }
}
