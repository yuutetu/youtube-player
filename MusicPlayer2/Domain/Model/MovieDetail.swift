//
//  MovieDetail.swift
//  MusicPlayer2
//
//  Created by 加賀江　優幸 on 2017/02/13.
//  Copyright © 2017年 Masayuki Kagae. All rights reserved.
//

import Decodable

struct MovieDetail {
    let duration: String
    var totalPlayTime: Int64? {
        return self.parseDuration(self.duration)
    }
    
    init(duration: String) {
        self.duration = duration
    }
    
    private func parseDuration(_ duration: String) -> Int64? {
        do {
            let regexp = try NSRegularExpression(pattern: "^PT([0-9]+)M([0-9]+)S$", options: [])
            guard let match = regexp.firstMatch(in: duration, options: [], range: NSMakeRange(0, duration.characters.count)) else {
                return nil
            }
            let minutes = Int64((duration as NSString).substring(with: match.rangeAt(1))) ?? 0
            let seconds = Int64((duration as NSString).substring(with: match.rangeAt(2))) ?? 0
            return minutes * 60 + seconds
        } catch {
            return nil
        }
    }
}

extension MovieDetail: APIModel {
    static func decode(_ json: Any) throws -> MovieDetail {
        return try MovieDetail(
            duration: json => "contentDetails" => "duration"
        )
    }
}
