//
//  Styles.swift
//  WeatherApplication
//
//  Created by Rachana  on 25/05/23.
//

import Foundation
import SwiftUI
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            //.frame(maxWidth: .infinity)
            .padding(15)
            .foregroundColor(.black)
            .background(
                Color.white.opacity(0.5) // Set the opacity of the VStack background color
            )
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}





struct SearchTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.white.opacity(0.5))
            .cornerRadius(5)
            .padding(.top, 30)

    }
}

struct HeadingTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .padding(10)
    }
}
struct MediumTextStyle: ViewModifier {
func body(content: Content) -> some View {
        content
.font(Font.system(size: 25, weight: .medium))
.foregroundColor(.white)
    }
    
}

struct SemiBoldTextStyle: ViewModifier {
func body(content: Content) -> some View {
        content
.font(Font.system(size: 45, weight: .semibold))
.foregroundColor(.white)
    }
    
}
