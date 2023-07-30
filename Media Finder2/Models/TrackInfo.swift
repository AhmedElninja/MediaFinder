//
//  TrackInfo.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 10/06/2023.
//

import Foundation

struct TrackInfo: Codable {
    let artworkUrl100: String
    let artistName: String
    let trackName: String
    let longDescription: String?
    let previewUrl: String?

}

