//
//  APIMultipleResponse.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/13.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import Decodable

struct APIMultipleResponse<T: APIModel> {
    let items: [T]
    let nextPageToken: String
}

extension APIMultipleResponse: APIModel {
    static func decode(_ json: Any) throws -> APIMultipleResponse<T> {
        return try APIMultipleResponse(
            items:          json => "items",
            nextPageToken:  json => "nextPageToken"
        )
    }
}
