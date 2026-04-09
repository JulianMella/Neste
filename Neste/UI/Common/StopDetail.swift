//
//  StopDetail.swift
//  Neste
//
//  Created by Julian on 08/04/2026.
//

import SwiftUI

struct StopDetail: View {
    @Environment(FavoriteStopViewModel.self) private var favoriteStopViewModel
    let transportTypes: [TransportType]
    let stopSearchResult: StopSearchResult
    let stopRowType: StopRowType
    @State private var selectedTab = 0
    
    var pickerItems: [(String, String?)] {
        transportTypes.map{($0.pickerText, nil)}
    }

    var body: some View {
        Divider()
        VStack(spacing: 16) {
            if transportTypes.count > 1 {
                SegmentedPicker(selection: $selectedTab, items: pickerItems)
                .frame(maxWidth: 200)
            }
            
            // TODO: Entur discussion, consider adding a refresh button.
            
            if let stopGroup = stopSearchResult.groupedStopMetadata[transportTypes[selectedTab]] {
                Group {
                    ForEach(stopGroup, id: \.self) { child in
                        StopLineRow(stop: child, hasChildrenIds: stopSearchResult.hasChildrenIds, parent: stopSearchResult.parentStop, stopRowType: stopRowType)
                    }
                }
                .onAppear {
                    if stopRowType == .favoriteStop {
                        let needsInitialFetch = stopGroup.allSatisfy { !favoriteStopViewModel.hasData(for: $0)}
                        
                        if needsInitialFetch {
                            Task {
                                await favoriteStopViewModel.loadArrivals(for: stopSearchResult, in: transportTypes[selectedTab])
                            }
                        } else {
                            favoriteStopViewModel.deleteStaleData(for: stopGroup)
                        }
                    }
                    
                    else if stopRowType == .stopSearch {
                        // TODO: load data for this specific tab
                    }
                }
                .onChange(of: selectedTab) {
                    if stopRowType == .favoriteStop {
                        let needsInitialFetch = stopGroup.allSatisfy { !favoriteStopViewModel.hasData(for: $0)}
                        
                        if needsInitialFetch {
                            Task {
                                await favoriteStopViewModel.loadArrivals(for: stopSearchResult, in: transportTypes[selectedTab])
                            }
                        } else {
                            favoriteStopViewModel.deleteStaleData(for: stopGroup)
                        }
                    }
                    
                    else if stopRowType == .stopSearch {
                        // TODO: load data for this specific tab
                    }
                }
            } else {
                Text("No transportation found at this stop")
                    .frame(maxWidth: .infinity)
            }
            
        }
        .padding(10)
    }
}

struct StopLineRow: View {
    @Environment(FavoriteStopViewModel.self) private var favoriteStopViewModel
    let stop: StopSearchResult.StopMetadata
    let hasChildrenIds: Bool
    let parent: GeocoderStop
    let stopRowType: StopRowType
    var isFavorited: Bool { favoriteStopViewModel.contains(child: stop, in: parent) }
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()
    
    // TODO: Set up timer for each row respective to the amount of time left before the next item that is not prune data must update its text string
    
    var body: some View {
        HStack {
            Text(stop.publicTransportNumber)
                .frame(width: 24, height: 24)
                // .padding(.horizontal, stop.publicTransportNumber.count > 1 ? 6 : 8) // TODO: Not satisfied with this result.
                .background(stop.transportType.color)
                .cornerRadius(6)
            
            Text(stop.finalDestination)
                .font(.system(size: 16))
            
            Spacer()
            
            if stopRowType == .stopSearch {
                Button {
                    if isFavorited {
                        favoriteStopViewModel.deleteFavorite(parent: parent, child: stop)
                    } else {
                        favoriteStopViewModel.addFavorite(parent: parent, hasChildrenIds: hasChildrenIds, child: stop)
                    }
                } label: {
                    Image(systemName: isFavorited ? "star.fill" : "star")
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
            }
            
            else if stopRowType == .favoriteStop {
                if let arrivals = favoriteStopViewModel.arrivalData[stop], arrivals.count > 1 {
                    Text(formatter.string(from: arrivals[0].aimedDepartureTime))
                    .font(.system(size: 16))
                    
                    HStack {
                        ForEach(1..<(arrivals.count < 4 ? arrivals.count : 4), id: \.self) { i in
                            Text(formatter.string(from: arrivals[i].aimedDepartureTime))
                                .foregroundStyle(.gray)
                                .frame(width: 45, alignment: .trailing)
                        }
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .contextMenu {
            if stopRowType == .favoriteStop {
                Button("Delete \(stop.finalDestination)") {
                    favoriteStopViewModel.deleteFavorite(parent: parent, child: stop) // TODO: Better naming
                }
            }
        }
    }
}
