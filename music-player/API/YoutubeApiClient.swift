//
//  YoutubeApiClient.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/04/16.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import RxSwift
import RxCocoa

class YoutubeApiClient: NSObject {
    static let defaultClient = YoutubeApiClient()
    let apiKey = "AIzaSyDLRGv2WnJZNzg1LvE4tbASEox3kbDsQVU"
    
    func request() -> Observable<(NSData, NSHTTPURLResponse)> {
        // TODO: エンドポイントの切り替え, パース処理, ログイン認証
        let request = NSURLRequest(URL: NSURL(string: "https://www.googleapis.com/youtube/v3/videos?part=id,snippet&chart=mostpopular&key=\(apiKey)")!)
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        return session.rx_response(request)
    }
}
