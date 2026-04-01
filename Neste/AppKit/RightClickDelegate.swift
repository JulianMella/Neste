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
        if let window = event.window, window.className.contains("NSStatusBar") {
            self.showMenu(in: window, at: event.locationInWindow)
        }
        return event
    }
    
    private func showMenu(in window: NSWindow, at point: NSPoint) {
        // Close the MenuBarExtra window if open
        for w in NSApp.windows where w.isVisible && w != window {
            w.close()
        }
        
        let menu = NSMenu()
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "")
        menu.addItem(quitItem)
        menu.popUp(positioning: nil, at: NSPoint(x: point.x, y: point.y), in: window.contentView)
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}
