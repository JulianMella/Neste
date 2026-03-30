//
//  RuterMenuBarApp.swift
//  RuterMenuBar
//
//  Created by Julian on 30/03/2026.
//

import SwiftUI
import SwiftData

@main
struct RuterMenuBarApp: App {
    @State private var test: String = ""
    
    var body: some Scene {
        MenuBarExtra("Test", systemImage: "number") {
            VStack {
                TextField(
                    "Testing",
                    text: $test
                )
            }
        }
        .menuBarExtraStyle(.window)
    }
}
