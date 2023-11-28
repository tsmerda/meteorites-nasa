//
//  PrimaryButton.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 26.11.2023.
//

import SwiftUI

struct PrimaryButton: View {
    
    private let icon: String?
    private let title: String
    private let action: () -> Void
    private let color: Color
    
    init(
        icon: String? = nil,
        title: String,
        action: @escaping () -> Void,
        color: Color = Color.accentColor
    ) {
        self.icon = icon
        self.title = title
        self.action = action
        self.color = color
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let iconName = icon {
                    Image(systemName: iconName)
                        .imageScale(.large)
                        .padding(.trailing, 4)
                }
                Text(title)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PrimaryButtonStyle(color: color))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var color: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, Padding.standard)
            .background(configuration.isPressed ? color.opacity(0.8) : color)
            .foregroundColor(Colors.textDark)
            .font(Fonts.body1)
            .cornerRadius(CornerRadius.big)
    }
}


#Preview {
    PrimaryButton(
        icon: "mappin.and.ellipse",
        title: "Primary Button",
        action: {}
        // color: Colors.warning
    )
}
