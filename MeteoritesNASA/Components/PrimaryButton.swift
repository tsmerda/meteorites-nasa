//
//  PrimaryButton.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 26.11.2023.
//

import SwiftUI

struct PrimaryButtonConfig {
    let icon: Image?
    let title: String
    let action: () -> Void
    let color: Color
    
    init(
        icon: Image? = nil,
        title: String,
        action: @escaping () -> Void,
        color: Color = Color.accentColor
    ) {
        self.icon = icon
        self.title = title
        self.action = action
        self.color = color
    }
}

struct PrimaryButton: View {
    let config: PrimaryButtonConfig
    
    init(config: PrimaryButtonConfig) {
        self.config = config
    }
    
    var body: some View {
        Button(action: config.action) {
            HStack(spacing: Spacing.small) {
                if let iconName = config.icon {
                    iconName
                        .imageScale(.large)
                }
                Text(config.title)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PrimaryButtonStyle(color: config.color))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var color: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, Padding.standard)
            .background(configuration.isPressed ? color.opacity(0.8) : color)
            .foregroundColor(Colors.black)
            .font(Fonts.body1)
            .cornerRadius(CornerRadius.big)
    }
}

#Preview {
    PrimaryButton(
        config: PrimaryButtonConfig(
            icon: Icons.mapPin,
            title: "Primary Button",
            action: {}
            // color: Colors.warning
        )
    )
}
