# Ruter MenuBar App — Project Specification
## Introduction

This document serves as the reference point for what I want this application to provide. The feature scope is laid out in order of increasing difficulty so that I can work on it iteratively.

### Why Am I Making This?

When I am working or surfing on my MacBook, I have little interest in picking up my phone. I just do not enjoy using it unless I am done with my day. This causes a pain point when I want to check what transportation I need to take through Ruter. I would have to unlock my phone by manually typing in my passcode (since my Face ID does not work), close out of whatever my phone currently has open, find the Ruter app, type out where I am and where I want to go, and then finally see the results. That is a lot of steps for something that should be quick.

Ruter already provides a web-based solution, but I have had bad results with it. The website can be buggy and takes a lot of time to load results for some reason. I just want something that is very quickly accessible from my computer. Since I am a macOS user, I came up with the idea of creating a MenuBarExtra-based application that connects directly to the Entur API to fetch the relevant results I need.

## Feature Scope

Since I am an individual developer working on this, I need to make sure the feature scope stays feasible by placing it under certain limitations.
The initial limitation is that this application will only work in Oslo for the most common transportation methods. These are classified as:

- Red bus
- Tram
- Metro

### Feature Requirements
The general requirement of this application is to answer the following question for users: "I am at position X and I want to get to position Y. How can I do so, and what are the alternatives?"

#### Tier 1 — Nearby Departures
The first and simplest solution:

The application detects where the user is currently located. With this geographical data, it fetches the nearest stops and when transportation is arriving at those stops.

This initial solution leaves the responsibility to the user to know the rest of the connections necessary to get where they want to be. The calculation of walking distance from the user's current position to a stop is also left to the user's own judgment. This is completely fine when the user knows the route well and ideally only needs one connection.

#### Tier 2 — Route Search
For more complex routes — where the user is not familiar with the area, the trip consists of multiple connections, or the travel is not for the immediate future but for a near future time — the user must have the ability to type in a route they want to take.

#### Tier 3 — Map Integration (Future)
Map integration is important but quite difficult to handle at this stage. Initially, this will work as a list-based solution. Map integration could eventually provide things such as:

Where the public transportation is currently located in real time
The full path that will be taken, both on foot and with transportation

But this is for another day.

## API Request Handling
The nearby stops data and the route search data require two different kinds of API requests.
Nearby Departures: This must be a persistent data set that is always immediately available when the user clicks the menu bar icon. It is important that the app does not fire an API request every time the user clicks the button. The transportation timetable is generally reliable, but things can change due to delays. There needs to be a balance between fetching an initial ground truth and then polling at a set interval to update the data in case of deviations.
Route Search: This will only perform an API call when the user explicitly submits a query.

## Additional Considerations

### User Experience

Default stop selection: Consider letting users pin favourite stops or a "home" and "work" location. This removes the dependency on geolocation accuracy and gives instant results without any location lookup.
Loading and empty states: Define what the user sees while data is loading for the first time, and what happens if there are no upcoming departures (e.g. late at night).
Real-time indicators: Show whether displayed times are based on the scheduled timetable or are real-time estimates adjusted for delays.
Relative vs. absolute time: Display departure times as both relative ("3 min") and absolute ("14:32") so users can quickly judge urgency.

### Technical

macOS location accuracy: CoreLocation on macOS uses Wi-Fi positioning rather than GPS, which is less precise than on iOS. This is another reason to support pinned locations as a fallback.
Entur API rate limits: Review the Entur API's rate limiting and terms of use. Make sure polling intervals respect these limits.
Caching strategy: Consider a layered approach — serve cached data instantly on open, then refresh in the background. Show a subtle "last updated" timestamp so the user knows how fresh the data is.
Offline and error handling: Define what happens when the Entur API is unreachable or slow. Displaying stale cached data with a clear "last updated X minutes ago" notice is far better than a spinner or blank screen.
App footprint: A MenuBarExtra app should be extremely lightweight. Be mindful of memory usage and background activity, especially if running a polling timer.

### Scope Creep to Watch Out For

Other transport modes: Ferries, regional trains, night buses — tempting to add, but each introduces edge cases. Stick to bus, tram, and metro until those work well.
Notifications and alerts: Push notifications for departures or delays sound useful but add significant complexity. Defer this.
Multi-city support: Entur covers all of Norway, so expanding beyond Oslo will be tempting. Keep the Oslo constraint until the core experience is solid.
Accessibility: Worth keeping in mind from the start (VoiceOver support, keyboard navigation in the popover), even if it is not the first priority.
