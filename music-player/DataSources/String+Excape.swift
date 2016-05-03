//
//  String+Excape.swift
//  music-player
//
//  Created by 加賀江　優幸 on 2016/05/03.
//  Copyright © 2016年 加賀江　優幸. All rights reserved.
//

import Foundation

extension String {
    func escapeStr() -> String {
        let raw: NSString = self
        let str = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,raw,"[].",":/?&=;+!@#$()',*",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))
        return str as String
    }
}
