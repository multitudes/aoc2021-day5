//
//  ContentView.swift
//  day5
//
//  Created by Laurent B on 19/12/2021.
//

import SwiftUI


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
                    /// I start by adding all the lines, in blue
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
                    
                    /// once the lines are drawn, add the intersections in red
                    let baseTransform = context.transform
                    for point in drawing.intersections {
                        let xPos = (point.x * (Int(size.width )) / drawing.canvasWidth)
                        let yPos = (point.y * (Int(size.height)) / drawing.canvasHeight)
                        let newPoint = CGPoint(x: xPos, y: yPos)
                        context.translateBy(x: newPoint.x, y: newPoint.y)
                        context.stroke(
                            Path(ellipseIn: CGRect(origin: CGPoint(x: -0.5, y: -0.5), size: CGSize(width: 1, height: 1))),
                            with: .color(.pink),
                            lineWidth: 4)
                        context.transform = baseTransform
                    }
                }
                /// aspectRatio one by one ensures the picture will not be skewed
                .aspectRatio(1, contentMode: .fit)
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

