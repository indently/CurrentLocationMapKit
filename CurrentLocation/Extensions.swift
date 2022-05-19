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
