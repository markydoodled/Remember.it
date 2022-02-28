//
//  PrimaryButtonStyle.swift
//  Remember.it
//
//  Created by Mark Howard on 06/02/2022.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        
    }
}
