import MapKit
import UIKit

class DetailViewController: UIViewController, UITableViewDataSource {
    var nearestLocations: [Location] = []
    static func newInstance() -> DetailViewController? {
        guard let result = UIStoryboard(
            name: "Detail", bundle: nil
        ).instantiateInitialViewController() as? DetailViewController else { return nil }

        // Do any additional setup after loading the view.

        return result
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nearestLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        let location = self.nearestLocations[indexPath.row]
        
        result.textLabel?.text = location.properties.name
        let distance = location.distanceToLocation(latitude: self.nearestLocations[0].geometry.coordinates[1],
                                                   longitude: self.nearestLocations[0].geometry.coordinates[0])
        result.detailTextLabel?.text = String(format: "%.2f miles", distance)

        return result
    }
}

