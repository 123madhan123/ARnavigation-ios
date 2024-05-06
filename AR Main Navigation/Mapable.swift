//
//  Mapable.swift
//  AR Main Navigation
//
//  Created by Prasanth on 13/02/24.
//

import Foundation
import MapKit

protocol Mapable: AnyObject  {
    var startingLocation: CLLocation! { get set }
    var mapView: MKMapView! { get set }
}

extension Mapable {
    
    func centerMapInInitialCoordinates() {
        if startingLocation != nil {
            DispatchQueue.main.async {
                self.mapView.setCenter(self.startingLocation.coordinate, animated: true)
                let latDelta: CLLocationDegrees = 0.004
                let lonDelta: CLLocationDegrees = 0.004
                let span = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: lonDelta) //MKCoordinateSpanMake(latDelta, lonDelta)
                let region = MKCoordinateRegion(center: self.startingLocation.coordinate, span: span) //MKCoordinateRegionMake(self.startingLocation.coordinate, span)
                self.mapView.setRegion(region, animated: false)
            }
        }
    }

}
