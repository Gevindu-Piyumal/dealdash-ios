//
//  LocationManager.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-26.
//

import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()

    private override init() {
        super.init()
        configureLocationManager()
    }

    let manager = CLLocationManager()
    weak var delegate: CLLocationManagerDelegate?

    private func configureLocationManager() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10
    }

    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        manager.delegate = delegate
        manager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
}
