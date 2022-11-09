//
//  MainViewModel.swift
//  AcmeMap
//
//  Created by Khateeb Hussain on 10/26/22.
//

import Combine
import Foundation
import MapKit

final class MainViewModel: ObservableObject {
    let locationService: LocationService
    
    @Published private(set) var locations: [Location] = []

    init(model:[Location]? = nil) {
        if let model = model {
            self.locations = model
        }
        self.locationService = LocationService()
    }
}

extension MainViewModel {
    func fetchLocations() {
        self.locationService.locations { result in
            switch result {
            case .success(let locations):
                self.locations = locations.filter{$0.geometry.type == .Point}
                return
            case .failure(_):
                return
            }
        }
    }
    
    func nearestThree(from coordinate: CLLocationCoordinate2D) -> [Location] {
        if locations.count < 3 {
            return locations
        }
        let sorted = locations.sorted(by:{
            $0.distanceToLocation(latitude: coordinate.latitude,
                                  longitude: coordinate.longitude) <
            $1.distanceToLocation(latitude: coordinate.latitude,
                                  longitude: coordinate.longitude)})
        return Array(sorted[0...2])
    }
}
