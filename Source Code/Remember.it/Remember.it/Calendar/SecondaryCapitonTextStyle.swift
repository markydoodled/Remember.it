//
//  SecondaryCapitonTextStyle.swift
//  Remember.it
//
//  Created by Mark Howard on 06/02/2022.
//

import Foundation
import SwiftUI

struct SecondaryCaptionTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

