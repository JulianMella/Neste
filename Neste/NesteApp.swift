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
    var body: some Scene {
        MenuBarExtra("Test", systemImage: "tram.fill") {
            VStack {
                Button(action: {
                    Task {
                        await FetchBislettOsloHardcoded()
                    }
                }){
                    Text("Fetch stop")
                }
            }
            .frame(width: 100, height: 200)
        }
        .menuBarExtraStyle(.window)
    }
}

func FetchBislettOsloHardcoded() async {
    let url = URL(string: "https://api.entur.io/geocoder/v1/autocomplete?text=Bislett, Oslo")!

    var request = URLRequest(url: url)
    request.setValue("julianmella-neste", forHTTPHeaderField: "ET-Client-Name")

    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(GeocoderResponse.self, from: data)
        print(decoded)
    } catch {
        print("Fetch error:", error)
    }
}

