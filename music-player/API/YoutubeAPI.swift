//
//  YoutubeAPI.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/04/29.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import Argo
import Foundation

protocol YoutubeAPIRequest {
    var requestURL: String { get }
    var deserializer: APIDeserializer { get }
}

struct YoutubeAPI {
    
}
