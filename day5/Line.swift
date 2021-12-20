//
//  Line.swift
//  day5
//
//  Created by Laurent B on 20/12/2021.
//

import SwiftUI

enum LineOrientation {
    case horizontal, vertical, diagonal, unknown
}

struct Line {
    var points = [Point]()
    var color = Color.blue // for swiftUI!
    var orientation: LineOrientation
    var width = 0.5
    
    var highestX: Int
    var highestY: Int
    var lowestX: Int
    var lowestY: Int
    
    init(pointA: Point, pointB: Point) {
        var allPoints: Set<Point> = []
        self.highestX = Int(max(pointA.x, pointB.x))
        self.highestY = Int(max(pointA.y, pointB.y))
        self.lowestX = Int(min(pointA.x, pointB.x))
        self.lowestY = Int(min(pointA.y, pointB.y))
        
        /// get orientation
        if pointA.y == pointB.y {
            self.orientation = .horizontal
            let y = lowestY
            for x in lowestX...highestX {
                let p = Point(x: x, y: y)
                allPoints.insert(p)
            }
            self.points = Array(allPoints)
        } else if pointA.x == pointB.x {
            self.orientation = .vertical
            let x = lowestX
            for y in lowestY...highestY {
                let p = Point(x: x, y: y)
                allPoints.insert(p)
            }
            self.points = Array(allPoints)
        } else {
            self.orientation = .diagonal
            let diff = pointB.x - pointA.x
            if pointA.x < pointB.x && pointA.y < pointB.y {
                var x = pointA.x
                var y = pointA.y
                for _ in 0...abs(diff) {
                    let p = Point(x: x, y: y)
                    allPoints.insert(p)
                    x += 1; y += 1
                }
            }
            if pointA.x > pointB.x && pointA.y < pointB.y {
                var x = pointA.x
                var y = pointA.y
                for _ in 0...abs(diff) {
                    let p = Point(x: x, y: y)
                    allPoints.insert(p)
                    x -= 1; y += 1
                }
            }
            if pointA.x < pointB.x && pointA.y > pointB.y {
                var x = pointA.x
                var y = pointA.y
                for _ in 0...abs(diff) {
                    let p = Point(x: x, y: y)
                    allPoints.insert(p)
                    x += 1; y -= 1
                }
            }
            if pointA.x > pointB.x && pointA.y > pointB.y {
                var x = pointA.x
                var y = pointA.y
                for _ in 0...abs(diff) {
                    let p = Point(x: x, y: y)
                    allPoints.insert(p)
                    x -= 1; y -= 1
                }
            }
            self.points = Array(allPoints)
        }
    }
}
