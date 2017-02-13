//
//  YoutubeAPI.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/13.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

protocol YoutubeAPIRequest {
    var requestURL: String { get }
    var deserializer: APIDeserializer { get }
}

struct YoutubeAPI {
    
}
