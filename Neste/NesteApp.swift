//
//  RuterMenuBarApp.swift
//  RuterMenuBar
//
//  Created by Julian on 30/03/2026.
//

import SwiftUI

@main
struct NesteApp: App {
    @NSApplicationDelegateAdaptor private var rightClickDelegate: RightClickDelegate
    
    var body: some Scene {
        MenuBarExtra("Test", image: "MenuBarIcon") {
            ContentView()
                .frame(minWidth: 450, maxHeight: 350)
                .fixedSize(horizontal: false, vertical: true)
                .padding(12)
        }
        .menuBarExtraStyle(.window)
    }
}
