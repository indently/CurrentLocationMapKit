//
//  ContentView.swift
//  CurrentLocation
//
//  Created by Federico on 18/05/2022.
//

import SwiftUI
import MapKit

extension View {
    func roundedMaterialBackground(cornerRadius: CGFloat) -> some View {
        self
            .background(.thinMaterial)
            .cornerRadius(cornerRadius)
            .padding()
    }
}

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    
    
    var body: some View {
        ZStack {
            mapView
            
            // MARK: Controls
            VStack {
                zoomView
                Spacer()
                positionDataView
            }
            
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
    
    // MARK: Zoom
    var zoomView: some View {
        Stepper("Zoom: \(locationManager.currentZoom, specifier: "%.2f")x",value: $locationManager.currentZoom, in: 0.10...2.1, step: 1.0)
            .padding()
            .roundedMaterialBackground(cornerRadius: 16)
    }
    
    // MARK: Current Position
    var positionDataView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Status: \(locationManager.statusString)")
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
        }
        .padding()
        .roundedMaterialBackground(cornerRadius: 16)
    }
    
}

