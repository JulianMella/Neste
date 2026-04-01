## Introduction

This document describes my understanding of AppKit in the context of what is required for this application.

SwiftUI provides high-level abstractions for building macOS interfaces, but certain system-level functionality, such as low-level event handling, is not directly exposed. In these cases, it is necessary to integrate AppKit to access underlying behavior.

In this application, I need to handle right-click interactions on a MenuBarExtra. SwiftUI does not provide an API for detecting right-click events in this context. To work around this limitation, I introduce an AppKit-based solution that listens for mouse events at the application level.

The goal is to allow the menu bar icon to respond to a right-click by showing a simple menu with a "Quit" option.

## NSApplicationDelegate

NSApplicationDelegate is an AppKit protocol that allows an object to respond to application-level lifecycle events. 

In this case, it is used as a stable entry point to set up event monitoring when the application starts.

Key properties:
- It is created once during application launch
- It lives for the entire lifetime of the application
- It runs on the main thread
- It provides access to the global application isntance (NSApp) and its windows

This makes it a suitable place to configure behavior that should apply across the entire application.

### Wiring into the SwiftUI lifecycle

SwiftUI manages the application lifecycle through the App protocol, rather than requiring manual setup as in traditional AppKit applications.

To integrate an AppKit delegate into this lifecycle, the @NSApplicationDelegateAdaptor property wrapper is used:

```swift
@NSApplicationDelegateAdaptor private var rightClickDelegate: RightClickDelegate
```

This property wrapper ensures that:
- The delegate object is created when the app launchers
- It is registered with the underlying AppKit system
- Its lifecycle is tied to the SwiftUI application

This acts as a bbridge between SwiftUI and AppKit

### Event Monitoring

Event monitoring is implemented using:

```swift
NSEvent.addLocalMonitorForEvents
```

This allows the application to intercept specific types of events and in this case, right mouse button clicks.

When a right-click event occurs:
1. The event is intercepted by the monitor
2. The associated window is inspected
3. If the event originated from the menu bar area, a custom menu is shown



