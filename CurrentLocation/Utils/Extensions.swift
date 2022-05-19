//
//  Extensions.swift
//  CurrentLocation
//
//  Created by Federico on 19/05/2022.
//

import Foundation
import MapKit
import SwiftUI

extension View {
    func roundedMaterialBackground(cornerRadius: CGFloat) -> some View {
        self
            .background(.thinMaterial)
            .cornerRadius(cornerRadius)
            .padding()
    }
}

extension Bundle {
    //MARK: - Used to decode local JSON files
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        do {
            let loadedData = try decoder.decode(T.self, from: data)
            return loadedData
        } catch {
            print(error)
            fatalError("Could not load \(file) from bundle.")
        }
    
    }
}
