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
                    try await GeocoderService().autocomplete(query: "Bislett, oslo")
                }
            }){
                Text("Fetch stop")
            }
        }
        .frame(width: 100, height: 200)
    }
}
