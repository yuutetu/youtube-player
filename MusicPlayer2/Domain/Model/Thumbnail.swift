//
//  Thumbnail.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/12.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import Decodable

struct Thumbnail {
    let url: URL
    let width: Int
    let height: Int
}

extension Thumbnail: APIModel {
    static func decode(_ json: Any) throws -> Thumbnail {
        return try Thumbnail(
            url:        json => "default" => "url",
            width:      (json =>? "default" =>? "width") ?? 90,
            height:     (json =>? "default" =>? "height") ?? 90
        )
    }
}
