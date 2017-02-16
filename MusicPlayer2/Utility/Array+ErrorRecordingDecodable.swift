//
//  Array+ErrorRecordingDecodable.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/16.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import Decodable

extension Array where Element: Decodable {
    public static func decode(_ json: Any, ignoreInvalidObjectsAndLogErrors: Bool) throws -> [Element] {
        if ignoreInvalidObjectsAndLogErrors {
            return try NSArray.decode(json).map {
                do {
                    return try Element.decode($0)
                } catch {
                    return nil
                }
                }.flatMap { $0 }
        } else {
            return try Array.decoder(Element.decode)(json)
        }
    }
}
