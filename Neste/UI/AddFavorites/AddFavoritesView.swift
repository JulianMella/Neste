//
//  AddFavoritesView.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

import SwiftUI

struct AddFavoritesView: View {
    @Binding var showAddFavorites: Bool
    
    var body: some View {
        Button("Hello") {
            showAddFavorites.toggle()
        }
    }
}
