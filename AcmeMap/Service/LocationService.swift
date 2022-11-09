//
//  LocationService.swift
//  AcmeMap
//
//  Created by Khateeb Hussain on 10/26/22.
//

import Foundation

protocol LocationService_Protocol {
    func locations(completion: @escaping (Result<[Location], Error>) -> Void)
}

class LocationService: LocationService_Protocol {

    private let httpClient: HttpClient
    private let jsonDecoder: JSONDecoder
    
    enum LocationServiceError: Error {
        case invalidUrl
    }
    
    struct LocationsResponseBody: Codable {
        let features: [Location]
    }

    init() {
        self.httpClient = HttpClient(session: URLSession.shared)
        self.jsonDecoder = JSONDecoder()
    }
    
    func locations(completion: @escaping (Result<[Location], Error>) -> Void) {
        guard let url = URL(string: "https://assets.acmeaom.com/interview-project/locations.json") else {
            completion(.failure(LocationServiceError.invalidUrl))
            return
        }
        httpClient.get(url: url) { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(HttpClientError.emptyData))
                return
            }
            do {
                let result = try self.jsonDecoder.decode(LocationsResponseBody.self, from: data)
                completion(.success(result.features))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

