//
//  HomeVC.swift
//  ARNavigation
//
//  Created by SAIL on 31/01/24.
//

import UIKit
import MapKit
import ARKit
import CoreLocation


class HomeVC: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private var annotationColor = UIColor.blue
    internal var annotations: [POIAnnotation] = []
    private var currentTripLegs: [[CLLocationCoordinate2D]] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
//    var delegate: StartViewControllerDelegate?
    var locationService: LocationService = LocationService()
//    var navigationService: NavigationService = NavigationService()
//    var type: ControllerType = .nav
    private var locations: [CLLocation] = []
    var startingLocation: CLLocation!
    var press: UILongPressGestureRecognizer!
    private var steps: [MKRoute.Step] = []
    var destinationLocation: CLLocationCoordinate2D! {
        didSet {
            setupNavigation()
        }
    }
    
    var ARLocationData: LocationData!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.resignFirstResponder()
        if ARConfiguration.isSupported {
            locationService.delegate = self
            guard let locationManager = locationService.locationManager else { return }
            locationService.startUpdatingLocation(locationManager: locationManager)
            press = UILongPressGestureRecognizer(target: self, action: #selector(handleMapTap(gesture:)))
            press.minimumPressDuration = 0.35
            mapView.addGestureRecognizer(press)
            mapView.delegate = self
        } else {
            presentMessage(title: "Not Compatible", message: "ARKit is not compatible with this phone.")
            return
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          // This method is called whenever the text in the search bar changes
          print("Search text changed to: \(searchText)")
        if searchText.count > 0 {
            self.getCoordinates(for: searchText) { coordinates, error in
                guard error == nil else {return}
                if let searchCoordinates = coordinates {
                    self.destinationLocation = searchCoordinates
                }
            }
        }
       
          // You can perform your search operations here
      }
//
//    // Sets destination location to point on map
    @objc func handleMapTap(gesture: UIGestureRecognizer) {
        if gesture.state != UIGestureRecognizer.State.began {
            return
        }
        // Get tap point on map
        let touchPoint = gesture.location(in: mapView)
        
        // Convert map tap point to coordinate
        let coord: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        destinationLocation = coord
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.setupNavigation()
    }
//
//    // Gets directions from from MapKit directions API, when finished calculates intermediary locations
//    
    func getCoordinates(for address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            if let placemark = placemarks?.first {
                completion(placemark.location?.coordinate, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    private func setupNavigation() {
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global(qos: .default).async {
            
            if self.destinationLocation != nil {
                self.getDirections(destinationLocation: self.destinationLocation, request: MKDirections.Request()) { steps in
                    for step in steps {
                        self.annotations.append(POIAnnotation(coordinate: step.getLocation().coordinate, name: "N " + step.instructions))
                    }
                    self.steps.append(contentsOf: steps)
                    group.leave()
                }
            }
            
            // All steps must be added before moving to next step
            group.wait()
            
            self.getLocationData()
        }
    }
// 
//    
    private func getLocationData() {
        
        for (index, step) in steps.enumerated() {
            setTripLegFromStep(step, and: index)
        }
        
        for leg in currentTripLegs {
            update(intermediary: leg)
        }
        centerMapInInitialCoordinates()
        DispatchQueue.main.async {
            self.showPointsOfInterestInMap(currentTripLegs: self.currentTripLegs)
        }
        
        addMapAnnotations()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let alertController = UIAlertController(title: "Navigate to your destination?", message: "You've selected destination.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No thanks.", style: .cancel, handler: { action in
                DispatchQueue.main.async {
                    self.destinationLocation = nil
                    self.annotations.removeAll()
                    self.locations.removeAll()
                    self.currentTripLegs.removeAll()
                    self.steps.removeAll()
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.removeOverlays(self.mapView.overlays)
                }
            })
            
            let okayAction = UIAlertAction(title: "Go!", style: .default, handler: { action in
                let destination = CLLocation(latitude: self.destinationLocation.latitude, longitude: self.destinationLocation.longitude)
                let data = ["annotations":self.annotations,
                            "destination":destination,
                            "currentTripLegs":self.currentTripLegs,
                            "steps":self.steps]
               // NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: data)
                self.ARLocationData = LocationData(destinationLocation: destination, annotations: self.annotations, legs: self.currentTripLegs, steps: self.steps)
                self.showFinalVC()
//                if let delegate = self.delegate {
//                    delegate.startNavigation(with: self.annotations, for: destination, and: self.currentTripLegs, and: self.steps)
//                } else {
//                    print("Delegate is nil. Make sure to set the delegate before calling startNavigation.")
//                }
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    private func showFinalVC() {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinalVC") as! FinalViewController
        nextVC.locationData = self.ARLocationData
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
//
//    // Gets coordinates between two locations at set intervals
//    private func setLeg(from previous: CLLocation, to next: CLLocation) -> [CLLocationCoordinate2D] {
//        return CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: previous, destinationLocation: next)
//    }
//    
//    // Add POI dots to map
    private func showPointsOfInterestInMap(currentTripLegs: [[CLLocationCoordinate2D]]) {
        mapView.removeAnnotations(mapView.annotations)
        for tripLeg in currentTripLegs {
            for coordinate in tripLeg {
                let poi = POIAnnotation(coordinate: coordinate, name: String(describing: coordinate))
                mapView.addAnnotation(poi)
            }
        }
    }
    
//    // Adds calculated distances to annotations and locations arrays
    private func update(intermediary locations: [CLLocationCoordinate2D]) {
        for intermediaryLocation in locations {
            annotations.append(POIAnnotation(coordinate: intermediaryLocation, name: String(describing:intermediaryLocation)))
            self.locations.append(CLLocation(latitude: intermediaryLocation.latitude, longitude: intermediaryLocation.longitude))
        }
    }
//    
//    // Determines whether leg is first leg or not and routes logic accordingly
    private func setTripLegFromStep(_ tripStep: MKRoute.Step, and index: Int) {
        if index > 0 {
            getTripLeg(for: index, and: tripStep)
        } else {
            getInitialLeg(for: tripStep)
        }
    }
    
    // Calculates intermediary coordinates for route step that is not first
    private func getTripLeg(for index: Int, and tripStep: MKRoute.Step) {
        let previousIndex = index - 1
        let previousStep = steps[previousIndex]
        let previousLocation = CLLocation(latitude: previousStep.polyline.coordinate.latitude, longitude: previousStep.polyline.coordinate.longitude)
        let nextLocation = CLLocation(latitude: tripStep.polyline.coordinate.latitude, longitude: tripStep.polyline.coordinate.longitude)
        let intermediarySteps = CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: previousLocation, destinationLocation: nextLocation)
        currentTripLegs.append(intermediarySteps)
    }
    
    // Calculates intermediary coordinates for first route step
    private func getInitialLeg(for tripStep: MKRoute.Step) {
        let nextLocation = CLLocation(latitude: tripStep.polyline.coordinate.latitude, longitude: tripStep.polyline.coordinate.longitude)
        let intermediaries = CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: startingLocation, destinationLocation: nextLocation)
        currentTripLegs.append(intermediaries)
    }
    
    // Prefix N is just a way to grab step annotations, could definitely get refactored
    private func addMapAnnotations() {
        
        annotations.forEach { annotation in
            
            // Step annotations are green, intermediary are blue
            DispatchQueue.main.async {
                if let title = annotation.title, title.hasPrefix("N") {
                    self.annotationColor = .green
                } else {
                    self.annotationColor = .blue
                }
                self.mapView?.addAnnotation(annotation)
                self.mapView.addOverlay(MKCircle(center: annotation.coordinate, radius: 0.2))
            }
        }
    }

}


extension HomeVC: LocationServiceDelegate, MessagePresenting, Mapable {
    
    // Once location is tracking - zoom in and center map
    func trackingLocation(for currentLocation: CLLocation) {
        startingLocation = currentLocation
        centerMapInInitialCoordinates()
    }
    
    // Don't fail silently
    func trackingLocationDidFail(with error: Error) {
        presentMessage(title: "Error", message: error.localizedDescription)
    }
}


extension HomeVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.1)
            renderer.strokeColor = annotationColor
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
}

extension HomeVC {
    func getDirections(destinationLocation: CLLocationCoordinate2D, request: MKDirections.Request, completion: @escaping ([MKRoute.Step]) -> Void) {
        var steps: [MKRoute.Step] = []
        
        let placeMark = MKPlacemark(coordinate: destinationLocation)
        
        request.destination = MKMapItem.init(placemark: placeMark)
        request.source = MKMapItem.forCurrentLocation()
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if error != nil {
                print("Error getting directions")
            } else {
                guard let response = response else { return }
                for route in response.routes {
                    steps.append(contentsOf: route.steps)
                }
                completion(steps)
            }
        }
    }
}

extension MKRoute.Step {
    func getLocation() -> CLLocation {
        return CLLocation(latitude: polyline.coordinate.latitude, longitude: polyline.coordinate.longitude)
    }
}
