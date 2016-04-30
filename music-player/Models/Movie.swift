//
//  Movie.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/04/29.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import Argo
import Curry

struct Movie {
    let snippet: MovieSnippet
}

extension Movie: APIModel {
    static func decode(json: JSON) -> Decoded<Movie> {
        return curry(self.init)
            <^> json <| "snippet"
    }
}
