//
//  RuterMenuBarApp.swift
//  RuterMenuBar
//
//  Created by Julian on 30/03/2026.
//

import SwiftUI
import SwiftData

@main
struct NesteApp: App {
    @State private var test: String = ""
    
    var body: some Scene {
        MenuBarExtra("Test", systemImage: "tram.fill") {
            VStack {
                Button(action: FetchOneHardcodedStop){
                    Text("Fetch stop")
                }
            }
        }
        .menuBarExtraStyle(.window)
    }
}

func FetchOneHardcodedStop() {
    print("To be implemented")
}
