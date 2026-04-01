//
//  ContentView.swift
//  Neste
//
//  Created by Julian on 01/04/2026.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
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
