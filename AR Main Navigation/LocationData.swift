//
//  LocationData.swift
//  AR Main Navigation
//
//  Created by Prasanth on 13/02/24.
//

import Foundation
import MapKit

struct LocationData {
    var destinationLocation: CLLocation!
    var annotations: [POIAnnotation]
    var legs: [[CLLocationCoordinate2D]]
    var steps: [MKRoute.Step]
}
