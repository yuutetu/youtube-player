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
        
        typealias ModelType = APIMultipleResponse<Movie>
        
        var requestURL: String {
            switch self {
            case .Popular:
                return "https://www.googleapis.com/youtube/v3/videos?part=id,snippet&chart=mostpopular"
            }
        }
        
        var deserializer: APIDeserializer {
            return ModelAPIDeserializer<APIMultipleResponse<Movie>>()
        }
    }
}
