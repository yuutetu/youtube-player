//
//  APIMultipleResponse.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/04/29.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import Argo
import Curry

struct APIMultipleResponse<T: APIModel where T.DecodedType == T> {
    let items: [T]
    let nextPageToken: String
}

extension APIMultipleResponse: APIModel {
    static func decode(json: JSON) -> Decoded<APIMultipleResponse<T>> {
        return curry(self.init)
            <^> json <|| "items"
            <*> json <| "nextPageToken"
    }
}
