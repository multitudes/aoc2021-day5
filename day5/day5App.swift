//
//  day5App.swift
//  day5
//
//  Created by Laurent B on 19/12/2021.
//

import SwiftUI

@main
struct day5App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Drawing())
        }
    }
}
