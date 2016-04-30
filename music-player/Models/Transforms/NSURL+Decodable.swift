//
//  NSURL+Decodable.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/04/29.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import Argo
import Foundation

extension NSURL: Decodable {
    public typealias DecodedType = NSURL
    
    public class func decode(j: JSON) -> Decoded<NSURL> {
        switch j {
        case .String(let urlString):
            return NSURL(string: urlString).map(pure) ?? .typeMismatch("URL", actual: j)
        default:
            return .typeMismatch("URL", actual: j)
        }
    }
}
