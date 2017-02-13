//
//  APISingleResponse.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/13.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import Decodable

struct APISingleResponse<T: APIModel> {
    let items: [T]
}

extension APISingleResponse: APIModel {
    static func decode(_ json: Any) throws -> APISingleResponse<T> {
        return try APISingleResponse(
            items: json => "items"
        )
    }
}
