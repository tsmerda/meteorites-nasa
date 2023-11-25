//
//  MeteoriteInfoModalView.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import SwiftUI

struct MeteoriteInfoModalView: View {
    @StateObject private var viewModel: MeteoriteInfoModalViewModel
    
    init(viewModel: MeteoriteInfoModalViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            topLabelView
            meteoriteDetailView
        }
        .padding(
            EdgeInsets(
                top: 32,
                leading: 16,
                bottom: 16,
                trailing: 16
            )
        )
    }
}

private extension MeteoriteInfoModalView {
    var topLabelView: some View {
        HStack(spacing: Spacing.standard) {
            Circle()
                .fill(Color.disabled)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "photo")
                        .imageScale(.large)
                        .foregroundColor(Colors.textDark)
                )
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text(viewModel.meteorite.name)
                    .font(Fonts.headline1)
                    .foregroundStyle(Colors.textDark)
                Text("Třída \(viewModel.meteorite.recclass)")
                    .foregroundStyle(Colors.textLight)
            }
            Spacer()
            Circle()
                .fill(Color.accentColor)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "map")
                        .imageScale(.large)
                        .foregroundColor(Colors.white)
                )
        }
        .padding(.bottom, Padding.standard)
    }
    var meteoriteDetailView: some View {
        VStack {
            HStack {
                Text("Detailní informace")
                    .font(Fonts.body1)
                    .foregroundStyle(Colors.textDark)
                Spacer()
                Text("ID: \(viewModel.meteorite.id)")
                    .font(Fonts.body1)
                    .foregroundStyle(Colors.textLight)
            }
            Divider()
            VStack(spacing: Spacing.small) {
                detailInfoRow("Vzdálenost od místa dopadu", "520 km")
                detailInfoRow("Hmotnost", viewModel.formattedMass(viewModel.meteorite.mass))
                detailInfoRow("Datum dopadu", viewModel.meteorite.year?.toFormattedDate(outputFormat: "d. MMMM yyyy"))
                detailInfoRow("Přesné souřadnice", viewModel.getCoordinates())
            }
            .padding(.top, Padding.small)
            Spacer()
        }
    }
    
    func detailInfoRow(_ label: String, _ value: String?) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value ?? "Unknown info")
        }
        .foregroundStyle(Colors.textDark)
        .font(Fonts.captions)
    }
}

#Preview {
    MeteoriteInfoModalView(
        viewModel: MeteoriteInfoModalViewModel(
            meteorite: Meteorite.example
        )
    )
}
