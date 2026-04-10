//
//  StopRow.swift
//  Neste
//
//  Created by Julian on 08/04/2026.
//

import SwiftUI

enum StopRowType {
    case stopSearch, favoriteStop
}

struct StopRow: View {
    let stopSearchResult: StopSearchResult
    let stopRowType: StopRowType
    @Binding var hoveredStopID: String?
    @Binding var stopIDClicked: String?
    let proxy: ScrollViewProxy
    
    @Environment(FavoriteStopViewModel.self) private var favoriteStopViewModel
    
    var parentStop: GeocoderStop {
        stopSearchResult.parentStop
    }
    
    var parentId: String {
        parentStop.id
    }
    
    var parentName: String {
        parentStop.name
    }
    
    var transportTypes: [TransportType] {
        Array(stopSearchResult.groupedStopMetadata.keys).sorted(by: { $0.sortOrder < $1.sortOrder })
    }
    
    private var bottomRadius: CGFloat {
        parentId == stopIDClicked ? 0 : 12
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                stopIDClicked = (stopIDClicked == parentId) ? nil : parentId
                withAnimation {
                    proxy.scrollTo(parentId)
                }
            } label: {
                VStack {
                    HStack(spacing: 8) {
                        Text(parentName)
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        Spacer()
                        ForEach(transportTypes, id: \.self) { transportType in
                            Image(systemName: transportType.sfSymbol)
                                .frame(width: 24, height: 24)
                                .background(transportType.color)
                                .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
                    .onHover { isHovered in
                        hoveredStopID = isHovered ? parentId : nil
                    }
                    .contextMenu{
                        if stopRowType == .favoriteStop {
                            Button("Delete \(parentName)") {
                                favoriteStopViewModel.deleteParent(parent: parentStop) //TODO: Better naming
                            }
                        }
                    }
                }
                .id(parentId)
                .background(parentId == hoveredStopID || parentId == stopIDClicked ? .white.opacity(0.08) : .clear)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: bottomRadius, bottomTrailingRadius: bottomRadius, topTrailingRadius: 12))
            }
            .buttonStyle(.plain)
            
            if parentId == stopIDClicked {
                StopDetail(transportTypes: transportTypes, stopSearchResult: stopSearchResult, stopRowType: stopRowType)
                    .background(.white.opacity(0.08))
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 12, bottomTrailingRadius: 12, topTrailingRadius: 0))
            }
        }
    }
}
