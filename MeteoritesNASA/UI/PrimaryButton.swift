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
    
    init(
        icon: String? = nil,
        title: String,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.action = action
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
        .buttonStyle(PrimaryButtonStyle())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, Padding.standard)
            .background(configuration.isPressed ? Color.accentColor.opacity(0.8) : Color.accentColor)
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
    )
}
