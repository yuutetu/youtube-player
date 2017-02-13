//
//  APISerializationValue.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/13.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import Decodable

struct CustomError: Error {
    let message: String
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

protocol APISerializationValue {
    
}

extension String: APISerializationValue {
    
}

extension Dictionary: APISerializationValue {
    
}

protocol APIDeserializer {
    func deserialize(data: Data) -> Result<APISerializationValue>
}

struct ModelAPIDeserializer<T>: APIDeserializer where T: APIModel, T: APISerializationValue {
    func deserialize(data: Data) -> Result<APISerializationValue> {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) else {
            return .failure(CustomError(message: "JSON deserialization failed."))
        }
        
        do {
            let result: T = try T.decode(json)
            return .success(result)
        } catch{
            return .failure(error)
        }
    }
}
