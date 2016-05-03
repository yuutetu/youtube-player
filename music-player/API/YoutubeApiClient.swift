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
    static let defaultClient = YoutubeApiClient()
    let apiKey = "AIzaSyDLRGv2WnJZNzg1LvE4tbASEox3kbDsQVU"
    
    func request(youtubeAPIRequest: YoutubeAPIRequest, pageToken: String? = nil) -> Observable<(Decoded<APISerializationValue>, NSHTTPURLResponse)> {
        // TODO: エンドポイントの切り替え, パース処理, ログイン認証
        let url: NSURL = {
            var url = "\(youtubeAPIRequest.requestURL)&key=\(apiKey)"
            if let pageToken = pageToken {
                url = url + "&pageToken=\(pageToken)"
            }
            return NSURL(string: url)!
        }()
        let request = NSURLRequest(URL: url)
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        return session.rx_response(request).map({ (data: NSData, response: NSHTTPURLResponse) -> (Decoded<APISerializationValue>, NSHTTPURLResponse) in
            return (youtubeAPIRequest.deserializer.deserialize(data), response)
        })
    }
}
