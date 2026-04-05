//
//  StopMetadataUtils.swift
//  Neste
//
//  Created by Julian on 05/04/2026.
//

import Foundation

func groupMetadata(_ metadata: [AddFavoritesResult.StopMetadata]) -> [TransportType: [AddFavoritesResult.StopMetadata]] {
    return Dictionary(grouping: metadata, by: \.transportType)
}

func sortMetadata(_ metadata: [AddFavoritesResult.StopMetadata]) -> [AddFavoritesResult.StopMetadata] {
    return metadata.sorted(by: {$0.publicTransportNumber.localizedStandardCompare($1.publicTransportNumber) == .orderedAscending})
}
