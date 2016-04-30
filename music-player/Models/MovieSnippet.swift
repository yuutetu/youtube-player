//
//  MovieSnippet.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/04/29.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import Argo
import Curry

struct MovieSnippet {
    let title: String
    let thumbnailURL: NSURL
    let thumbnailWidth: Int
    let thumbnailHeight: Int
}

extension MovieSnippet: APIModel {
    static func decode(json: JSON) -> Decoded<MovieSnippet> {
        return curry(self.init)
            <^> json <| "title"
            <*> json <| ["thumbnails", "default", "url"]
            <*> json <| ["thumbnails", "default", "width"]
            <*> json <| ["thumbnails", "default", "height"]
    }
}
