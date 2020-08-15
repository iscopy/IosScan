//
//  Strings.swift
//  GaoPei
//
//  Created by iscopy on 2020/6/30.
//  Copyright © 2020 xolo. All rights reserved.
//

import UIKit

class Strings: NSObject {
    //返回第一次出现的指定子字符串在此字符串中的索引
    //（如果backwards参数设置为true，则返回最后出现的位置）
    public static func positionOf(code:String, sub:String, backwards:Bool = false)->Int {
        var pos = -1
        if let range = code.range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = code.distance(from:code.startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
}
