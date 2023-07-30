//
//  APIManger.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 10/06/2023.
//

import Foundation
import Alamofire

class APIManager {
    static func searchTrack(contentType: String, term: String, completion: @escaping (_ trackInfo: [TrackInfo]?, _  error: Error?) -> Void) {
        
        let parameters: [String: Any] = ["term": term, "media": contentType]
        
        AF.request(APIMangers.baseURL, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { response in
            
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            
            guard let data = response.data else {
                print("couldn't get data from this API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let trackResponse = try decoder.decode(TrackResponse.self, from: data)
                
                guard let track = trackResponse.results.first else {
                    completion(nil, nil)
                    return
                }
                
                let trackInfo = trackResponse.results.map { track in
                    TrackInfo(artworkUrl100: track.artworkUrl100,
                              artistName: track.artistName,
                              trackName: track.trackName,
                              longDescription: track.longDescription,
                              previewUrl: track.previewUrl)
                }
                completion(trackInfo, nil)
            } catch {
                completion(nil, error)
            }
                       
        }
    }
}






