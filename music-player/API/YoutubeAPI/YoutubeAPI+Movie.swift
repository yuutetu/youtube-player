//
//  YoutubeAPI+Movie.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/04/29.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import Argo
import Foundation

extension YoutubeAPI {
    enum Movies: YoutubeAPIRequest {
        case Popular
        case Search(query: String)
        
        var requestURL: String {
            switch self {
            case .Popular:
                return "https://www.googleapis.com/youtube/v3/videos?part=id,snippet&chart=mostpopular"
            case .Search(let query):
                return "https://www.googleapis.com/youtube/v3/search?part=id,snippet&q=\(query)"
            }
        }
        
        var deserializer: APIDeserializer {
            return ModelAPIDeserializer<APIMultipleResponse<Movie>>()
        }
    }
}
