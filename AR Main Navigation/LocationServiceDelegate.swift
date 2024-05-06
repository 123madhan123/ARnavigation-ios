//
//  LocationServiceDelegate.swift
//  AR Main Navigation
//
//  Created by Prasanth on 13/02/24.
//


import CoreLocation

protocol LocationServiceDelegate: class {
    func trackingLocation(for currentLocation: CLLocation)
    func trackingLocationDidFail(with error: Error)
}
