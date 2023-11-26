//
//  MeteoriteRowView.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import SwiftUI

struct MeteoriteRowView: View {
    let recclass: String
    let name: String?
    let year: String?
    let mass: String?
    
    init(
        recclass: String = "",
        name: String? = "",
        year: String? = "",
        mass: String? = ""
    ) {
        self.recclass = recclass
        self.name = name
        self.year = year
        self.mass = mass
    }
    
    var body: some View {
        HStack(spacing: Spacing.standard) {
            imageView
            infoView
        }
    }
}

private extension MeteoriteRowView {
    @ViewBuilder
    var imageView: some View {
        Image("meteorite-icon")
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 60)
            .cornerRadius(CornerRadius.standard)
            .padding(Padding.small)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.big)
                    .stroke(Colors.textLight, lineWidth: 1)
                    .opacity(0.4)
            )
    }
    var infoView: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text(recclass)
                .font(Fonts.captions)
                .foregroundStyle(Colors.textLight)
            Text(name ?? "Unknown name")
                .font(Fonts.headline1)
                .foregroundStyle(Colors.textDark)
            HStack {
                if let massText = mass {
                    Image(systemName: "scalemass")
                    Text(massText)
                        .font(Fonts.body1)
                }
                Spacer()
                Image(systemName: "clock")
                Text(year?.toFormattedDate() ?? "Unknown date")
                    .font(Fonts.body1)
            }
            .foregroundStyle(Colors.textDark)
        }
    }
}

#Preview {
    MeteoriteRowView(
        recclass: "L5",
        name: "Aachen",
        year: "1880-01-01T00:00:00.000",
        mass: "21"
    )
    .previewLayout(.sizeThatFits)
}
