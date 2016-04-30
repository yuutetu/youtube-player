//
//  YoutubeApiClient.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/04/16.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import RxSwift
import RxCocoa
import Argo

class YoutubeApiClient: NSObject {
//    typealias ModelType
    static let defaultClient = YoutubeApiClient()
    let apiKey = "AIzaSyDLRGv2WnJZNzg1LvE4tbASEox3kbDsQVU"
    
    func request(youtubeAPIRequest: YoutubeAPIRequest) -> Observable<(Decoded<APISerializationValue>, NSHTTPURLResponse)> {
        // TODO: エンドポイントの切り替え, パース処理, ログイン認証
        let request = NSURLRequest(URL: NSURL(string: "\(youtubeAPIRequest.requestURL)&key=\(apiKey)")!)
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        return session.rx_response(request).map({ (data: NSData, response: NSHTTPURLResponse) -> (Decoded<APISerializationValue>, NSHTTPURLResponse) in
            return (youtubeAPIRequest.deserializer.deserialize(data), response)
        })
    }
}
