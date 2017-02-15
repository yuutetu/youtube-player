//
//  YoutubeAPIClient.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/13.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import RxSwift
import RxCocoa
import Decodable

class YoutubeAPIClient: NSObject {
    static let `default` = YoutubeAPIClient()
    let apiKey = "AIzaSyCZ6nUa0IQW5cu4rG_rCKqoPNi-njw2kM8"
    
    func request(_ youtubeAPIRequest: YoutubeAPIRequest, pageToken: String? = nil) -> Observable<(Result<APISerializationValue>, HTTPURLResponse)> {
        // TODO: エンドポイントの切り替え, パース処理, ログイン認証
        let url: URL = {
            var url = "\(youtubeAPIRequest.requestURL)&key=\(apiKey)"
            if let pageToken = pageToken {
                url = url + "&pageToken=\(pageToken)"
            }
            return URL(string: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)!
        }()
        let request = URLRequest(url: url)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session.rx.response(request: request).map({ (response: HTTPURLResponse, data: Data) -> (Result<APISerializationValue>, HTTPURLResponse) in
            return (youtubeAPIRequest.deserializer.deserialize(data: data), response)
        })
    }
}
