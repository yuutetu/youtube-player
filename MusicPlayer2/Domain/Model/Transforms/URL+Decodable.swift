//
//  URL+Decodable.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/13.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import Decodable

extension URL: Decodable {
    public typealias DecodedType = NSURL
    
    public static func decode(_ json: Any) throws -> URL {
        guard let urlString = json as? String, let url = URL(string: urlString) else {
            throw CustomError(message: "URL type mismatch: " + String(describing: json))
        }
        
        return url
    }
}
