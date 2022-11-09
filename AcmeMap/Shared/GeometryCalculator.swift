//
//  GeometryCalculator.swift
//  AcmeMap
//
//  Created by Khateeb Hussain on 10/27/22.
//

import Foundation

class GeometryCalculator {
    static let shared = GeometryCalculator()
    func degreesToRadians(degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }

    func distanceInMilesBetweenEarthCoordinates(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {

        let earthRadiusMiles: Double = 3958.8

        let dLat = degreesToRadians(degrees: lat2 - lat1)
        let dLon = degreesToRadians(degrees: lon2 - lon1)

        let lat1 = degreesToRadians(degrees: lat1)
        let lat2 = degreesToRadians(degrees: lat2)

        let a = sin(dLat/2) * sin(dLat/2) +
        sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        return earthRadiusMiles * c
    }
}
