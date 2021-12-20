//
//  ContentView.swift
//  day5
//
//  Created by Laurent B on 19/12/2021.
//

import SwiftUI


struct Line {
    var points = [Point]()
    var color = Color.blue // for swiftUI!
    var orientation: LineOrientation
    var width = 0.5
    
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
    var highestX: Int
    var highestY: Int
    var lowestX: Int
    var lowestY: Int
}

struct Point : Hashable {
    let x: Int
    let y: Int
    init(x: Int = 0, y: Int = 0) {
        self.x = x; self.y = y
    }
}

class Drawing: ObservableObject {
    let canvasWidth: Int
    let canvasHeight: Int
    let lines: [Line]
    let intersections: [Point]
   
    init() {
        let input: [Line] = getInputDay5()
        
        /// this if I wantto draw them on the iPad later
        self.canvasWidth = input.reduce(0) { max($0, Int($1.highestX)) }
        self.canvasHeight = input.reduce(0) { Int(max($0, Int($1.highestY))) }
        print("canvasWidth \(canvasWidth), canvasHeight \(canvasHeight)")
        self.lines = input
        self.intersections = getIntersections(for: input)
    }
    
 

}

struct ContentView: View {
    @EnvironmentObject var drawing: Drawing
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Advent of code 2021\n - Day5 - Hydrothermal Venture")
                    .font(.subheadline).bold()
                    .multilineTextAlignment(.center)
                    .padding()
                Text("Example data")
                    .font(.body).bold()
//                Text("Solution")
//                    .font(.body).bold()
                Canvas {context, size in
                    for line in drawing.lines {
                        //  let transform = context.transform
                        var path = Path()
                        /// create a line
                        var newLine = [CGPoint]()
                        for point in line.points {
                            let xPos = (point.x * (Int(size.width )) / drawing.canvasWidth)
                            let yPos = (point.y * (Int(size.height)) / drawing.canvasHeight)
                            let newPoint = CGPoint(x: xPos, y: yPos)
                            newLine.append(newPoint)
                        }
                        /// and add it to the canvas
                        path.addLines(newLine)
                        context.stroke(path, with: .color(line.color),style: StrokeStyle(lineWidth: line.width, lineCap: .round, lineJoin: .round ))
                    }
                    /// once the lines are drawn, add the intersections
                    let baseTransform = context.transform
                    for point in drawing.intersections {
                        let xPos = (point.x * (Int(size.width )) / drawing.canvasWidth)
                        let yPos = (point.y * (Int(size.height)) / drawing.canvasHeight)
                        let newPoint = CGPoint(x: xPos, y: yPos)
                        context.translateBy(x: newPoint.x, y: newPoint.y)
//                        let image = Image(systemName: "wind").resizable().frame(width: 10, height: 10)
//                        context.draw( Image(systemName: "exclamationmark.circle.fill"), at: .zero)
                        context.stroke(
                            Path(ellipseIn: CGRect(origin: CGPoint(x: -0.5, y: -0.5), size: CGSize(width: 1, height: 1))),
                                with: .color(.pink),
                            lineWidth: 4)
                        context.transform = baseTransform
                    }
                }
                .aspectRatio(1, contentMode: .fit)
              //  .frame(width: 400, height: 400, alignment: .center)
                //.ignoresSafeArea()
                .padding()
                .border(Color.blue, width: 1)
                
                Spacer()
            }
            .padding(30)
            .navigationTitle("Plotting On Canvas with SwiftUI")
        }
        .navigationViewStyle(.stack)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Drawing())
        
    }
}


enum LineOrientation {
    case horizontal, vertical, diagonal, unknown
}

func checkIntersections(for input: [Line]) -> Int {
    /// empty start
    var intersections: Set<Point> = []
    var accumulator: Set<Point> = Set(input.first!.points)
    for line in input.dropFirst() {
        let intersection = accumulator.intersection(Set(line.points))
        intersections = intersections.union(intersection)
        accumulator = accumulator.union(Set(line.points))
    }
    return intersections.count
}


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

extension String {
    func getTrimmedCapturedGroupsFrom(regexPattern: String)-> [String]? {
        let text = self
        let regex = try? NSRegularExpression(pattern: regexPattern)
        
        let match = regex?.firstMatch(in: text, range: NSRange(text.startIndex..., in: text))
        
        if let match = match {
            return (0..<match.numberOfRanges).compactMap {
                if let range = Range(match.range(at: $0), in: text) {
                    return $0 > 0 ? String(text[range]).trimmingCharacters(in: .whitespaces) : nil
                }
                return nil
            }
        }
        return nil
    }
}
