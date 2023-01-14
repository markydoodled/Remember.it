//
//  PrimaryButtonStyle.swift
//  Remember.it
//
//  Created by Mark Howard on 13/01/2023.
//

import Foundation
import SwiftUI

//Custom Button Style
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}
