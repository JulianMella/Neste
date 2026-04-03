//
//  FavoritesView.swift
//  Neste
//
//  Created by Julian on 03/04/2026.
//

import SwiftUI

struct FavoriteStopView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("12")
                    .font(.system(size: 16))
                    .bold()
                    .frame(width: 32, height: 28)
                    .background(.blue)
                    .cornerRadius(8)
                Text("Majorstuen")
                    .font(.system(size: 16))
                Spacer(minLength: 24)
                Text("Nå")
                    .font(.system(size: 16))
                    .bold()
            }
            Divider()
            HStack {
                Text("2 min")
                    .foregroundStyle(.gray)
                Text("5 min")
                    .foregroundStyle(.gray)
                Text("12 min")
                    .foregroundStyle(.gray)
                Text("13:12")
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    FavoriteStopView()
}

