//
//  Movie.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/12.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import Decodable

struct Movie {
    let id: String
    let title: String?
    let thumbnail: Thumbnail?
}

extension Movie: APIModel {
    static func decode(_ json: Any) throws -> Movie {
        return try Movie(
            id: json => "id",
            title: json =>? "snippet" =>? "title",
            thumbnail: json =>? "snippet" =>? "thumbnails"
        )
    }
}
