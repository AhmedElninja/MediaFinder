//
//  TrackResponse.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 10/06/2023.
//

import Foundation

struct TrackResponse: Codable {
    let resultCount: Int
    let results: [TrackInfo]
}


