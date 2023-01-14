//
//  SecondaryCaptionTextStyle.swift
//  Remember.it
//
//  Created by Mark Howard on 13/01/2023.
//

import Foundation
import SwiftUI

//Custom Caption Style
struct SecondaryCaptionTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(.secondary)
    }
}
