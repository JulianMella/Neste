//
//  RuterMenuBarApp.swift
//  RuterMenuBar
//
//  Created by Julian on 30/03/2026.
//

import SwiftUI

@main
struct NesteApp: App {
    @NSApplicationDelegateAdaptor(RightClickDelegate.self) var rightClickDelegate
    
    var body: some Scene {
        MenuBarExtra("Test", systemImage: "tram.fill") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}
