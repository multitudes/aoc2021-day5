//
//  Point.swift
//  day5
//
//  Created by Laurent B on 20/12/2021.
//

import Foundation

struct Point : Hashable {
    let x: Int
    let y: Int
    init(x: Int = 0, y: Int = 0) {
        self.x = x; self.y = y
    }
}
