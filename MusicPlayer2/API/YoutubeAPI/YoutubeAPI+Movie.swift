//
//  YoutubeAPI+Movie.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/13.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import Decodable
import Foundation

extension YoutubeAPI {
    struct Movie: YoutubeAPIRequest {
        let id: String
        var requestURL: String {
            return "https://www.googleapis.com/youtube/v3/videos?id=\(id)&part=id,contentDetails,player"
        }
        var deserializer: APIDeserializer {
            return ModelAPIDeserializer<APISingleResponse<MusicPlayer2.MovieDetail>>()
        }
    }
    
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
            return ModelAPIDeserializer<APIMultipleResponse<MusicPlayer2.Movie>>()
        }
    }
}
