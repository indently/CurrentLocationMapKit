//
//  LocationManager.swift
//  CurrentLocation
//
//  Created by Federico on 18/05/2022.
//

// Requires: NSLocationWhenInUseUsageDescription in Plist

// Grabbed from: https://stackoverflow.com/questions/57681885/how-to-get-current-location-using-swiftui-without-viewcontrollers

import Foundation
import CoreLocation
import Combine
import MapKit
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    @Published var currentZoom: Double = 0.2
    @Published var speed = 0.0
    @Published var isTracking = true
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        
        // Requires: Required background modes in plist
        locationManager.allowsBackgroundLocationUpdates = true
        startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        isTracking = false
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        isTracking = true
        locationManager.startUpdatingLocation()
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    // Returns the current location status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    // Updates location info
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        lastLocation = location
        latitude = lastLocation?.coordinate.latitude ?? 0
        longitude = lastLocation?.coordinate.longitude ?? 0
        
        withAnimation {
            mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: currentZoom, longitudeDelta: currentZoom))
            
            // Get speed in km/h (speed is returned in metres per second)
            speed = (lastLocation?.speed ?? 0) * 60 * 60 / 1000
            
            print(speed)
            switch(speed) {
            case 0...25:
                currentZoom = 0.005
            case 26...50:
                currentZoom = 0.02
            case 51...100:
                currentZoom = 0.04
            case 101...:
                currentZoom = 0.06
            default:
                print("")
            }
            
            
        }
        
        
        // print(#function, location)
    }
}
