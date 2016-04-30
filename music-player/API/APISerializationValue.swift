//
//  APISerializationValue.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/04/29.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import Argo

protocol APISerializationValue {
    
}

extension String: APISerializationValue {
    
}

extension Dictionary: APISerializationValue {

}

protocol APIDeserializer {
    func deserialize(data: NSData) -> Decoded<APISerializationValue>
}

struct ModelAPIDeserializer<T where T: APIModel, T: APISerializationValue, T == T.DecodedType>: APIDeserializer {
    func deserialize(data: NSData) -> Decoded<APISerializationValue> {
        guard let json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) else {
            return .Failure(.Custom("JSON deserialization failed."))
        }
        
        let result: Decoded<T> = decode(json)
        
        switch result {
        case .Success(let t):
            return .Success(t)
        case .Failure(let e):
            return .Failure(e)
        }
    }
}
