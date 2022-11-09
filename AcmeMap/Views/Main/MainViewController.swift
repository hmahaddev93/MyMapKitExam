import MapKit
import UIKit
import Combine

class MainViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet private var mapView: MKMapView!

    private var viewModel:MainViewModel = MainViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindViewModel()
        viewModel.fetchLocations()
    }
    
    private func bindViewModel() {
        viewModel.$locations
            .sink { [weak self] in
                self?.renderLocations(locations: $0)
            }
            .store(in: &cancellables)
    }
    
    private func renderLocations(locations: [Location]) {
        for location in locations {
            addAnnotation(lat: location.geometry.coordinates[1], long: location.geometry.coordinates[0])
        }
        // Centeralize the last location
        if let lastLocation = locations.last {
            mapView.setCenter(CLLocationCoordinate2D(latitude: lastLocation.geometry.coordinates[1], longitude: lastLocation.geometry.coordinates[0]), animated: true)
        }
    }

    private func addAnnotation(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = .init(latitude: lat, longitude: long)
        mapView.addAnnotation(annotation)
    }

    private func presentDetail(locations: [Location]) {
        guard let detail = DetailViewController.newInstance() else { return }
        detail.nearestLocations = locations
        present(detail, animated: true)
    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        print(annotation.coordinate)
        presentDetail(locations: viewModel.nearestThree(from: annotation.coordinate))
    }
}
