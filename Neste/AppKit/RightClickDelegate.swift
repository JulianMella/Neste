//
//  RightClickDelegate.swift
//  Neste
//
//  Created by Julian on 01/04/2026.
//
//  Read AppkitDelegate.md to get a better understanding of this code

import SwiftUI

class RightClickDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSEvent.addLocalMonitorForEvents(matching: .rightMouseDown, handler: handleRightClick)
    }
    
    private func handleRightClick(_ event: NSEvent) -> NSEvent? {
        // Make sure that the event only goes through for a window of type statusBar
        if let window = event.window, window.level == .statusBar {
            self.showMenu(in: window, at: event.locationInWindow)
        }
        return event
    }
    
    private func showMenu(in window: NSWindow, at point: NSPoint) {
        // Close the MenuBarExtra window if open
        // w.level == .popUpMenu is a bit brittle. If it ends up closing other windows such as Settings, it must be changed.
        for w in NSApp.windows where w.isVisible && w != window && w.level == .popUpMenu {
            w.close()
        }
        
        let menu = NSMenu()
        let quitItem = NSMenuItem(title: NSLocalizedString("Quit", comment: "Quit the application"), action: #selector(quitApp), keyEquivalent: "")
        menu.addItem(quitItem)
        menu.popUp(positioning: nil, at: NSPoint(x: point.x, y: point.y), in: window.contentView)
    }
    
    // NSApp.terminate can be directly called from the selector in quitItem. The issue with this is that, for some reason, it forces the Quit button to have an x icon next to it. This was the simplest way to get rid of that icon. Kinda hacky, weird and cool..
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}
