//
//  ContentView.swift
//  CurrentLocation
//
//  Created by Federico on 18/05/2022.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            mapView
            
            // MARK: Controls
            VStack {
                Spacer()
                positionDataView
            }
        }
        .overlay(alignment: .topTrailing) {
            trackingButton
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    // MARK: MapView
    var mapView: some View {
        Map(coordinateRegion: $locationManager.mapRegion, showsUserLocation: true)
            .ignoresSafeArea()
    }
    
    
    // MARK: Current Position
    var positionDataView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Latitude: \(locationManager.latitude)")
                Text("Longitude: \(locationManager.longitude)")
            }
            Spacer()
            ZStack {
                Circle()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.blue.opacity(0.9))
                VStack {
                    Text("\(locationManager.speed, specifier: "%.2f")")
                        .bold()
                    Text("km/h")
                        .font(.caption2)
                }
                .animation(nil, value: locationManager.speed)
                .foregroundColor(.white)
            }
            .padding(4)
            .background(Circle()
                .foregroundColor(.white))
        }
        .padding()
        .roundedMaterialBackground(cornerRadius: 16)
    }
    
    // MARK: Tracking Button
    var trackingButton: some View {
        Button {
            if locationManager.isTracking {
                locationManager.stopUpdatingLocation()
            } else {
                locationManager.startUpdatingLocation()
            }
        } label: {
            Image(systemName: "location.circle.fill")
                .foregroundColor(locationManager.isTracking ? .blue : .gray)
        }
        .background(Circle()
            .foregroundColor(.white))
        .font(.system(size: 50))
        .frame(width: 50, height: 50)
    }
    
}

