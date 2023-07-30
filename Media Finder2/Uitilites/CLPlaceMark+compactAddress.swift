//
//  CLPlaceMark+compactAddress.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 08/05/2023.
//

import MapKit

extension CLPlacemark {
    var compactAddress: String? {
        if let name = name {
            var result = name
            if let street = thoroughfare {
                result += ", \(street)"
            }
            if let city = locality {
                result += ", \(city)"
            }
            if let country = country {
                result += ", \(country)"
            }
            return result
        }
        return nil
    }
}
