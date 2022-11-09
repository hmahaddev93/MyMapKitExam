//
//  Location.swift
//  AcmeMap
//
//  Created by Khateeb Hussain on 10/26/22.
//

import Foundation

struct Location: Codable {
    let id: String
    let type: String
    let geometry: Geometry
    let properties: Properties
    
    func distanceToLocation(latitude: Double, longitude: Double)  -> Double {
        return GeometryCalculator.shared.distanceInMilesBetweenEarthCoordinates(
            lat1: latitude, lon1: longitude,
            lat2: geometry.coordinates[1], lon2: geometry.coordinates[0])
    }
}

struct Geometry: Codable {
    let type: GeometryType
    let coordinates: [Double]
}

struct Properties: Codable {
    let name: String
}

enum GeometryType: String, Codable {
    case Point
    case LineString
    case Polygon
    case MultiPoint
    case MultiLineString
    case MultiPolygon
    case unknown
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)
        
        if let geometryType = GeometryType(rawValue: rawString) {
            self = geometryType
        } else {
            self = .unknown
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot initialize from invalid String value \(rawString)")
        }
    }
}

