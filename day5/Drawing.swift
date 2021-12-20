//
//  Drawing.swift
//  day5
//
//  Created by Laurent B on 20/12/2021.
//

import SwiftUI


/// This class is observable because it will be passed into the environment
class Drawing: ObservableObject {
    private(set) var canvasWidth: Int = 0
    private(set) var canvasHeight: Int = 0
    private(set) var lines: [Line] = []
    private(set) var intersections: [Point] = []
    
    init() {
        let input: [Line] = getInputDay5()
        self.canvasWidth = input.reduce(0) { max($0, Int($1.highestX)) }
        self.canvasHeight = input.reduce(0) { Int(max($0, Int($1.highestY))) }
        self.lines = input
        self.intersections = getIntersections(for: input)
    }
    
    /// get the solution already! But because in this app I will visualize the points, I will be passing this array to the canvas
    func getIntersections(for input: [Line]) -> [Point] {
        /// empty start
        var intersections: Set<Point> = []
        var accumulator: Set<Point> = Set(input.first!.points)
        for line in input.dropFirst() {
            let intersection = accumulator.intersection(Set(line.points))
            intersections = intersections.union(intersection)
            accumulator = accumulator.union(Set(line.points))
        }
        return Array(intersections)
    }
    
    /// get the input. Change the name of the file to get the other input, "input-5a" is the example, "input-5" is the real thing
    func getInputDay5() -> [Line] {
        var input: [Line] = []
        do {
            if let inputFileURL = Bundle.main.url(forResource: "input-5a", withExtension: "txt") {
                do {
                    input = try String(contentsOf: inputFileURL)
                        .split(separator: "\n")
                        .map {
                            let row: [String] = String($0).getTrimmedCapturedGroupsFrom(regexPattern: "(\\d+),(\\d+) -> (\\d+),(\\d+)") ?? []
                            return Line(
                                pointA: Point(x: Int(row[0])!, y: Int(row[1])!),
                                pointB: Point(x: Int(row[2])!, y: Int(row[3])!))
                        }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return input
    }
}
