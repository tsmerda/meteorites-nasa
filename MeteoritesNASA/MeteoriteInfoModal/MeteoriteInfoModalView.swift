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
            Spacer()
            if viewModel.withRouteButton {
                routeButton
            }
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
                Text(viewModel.meteorite?.name ?? "")
                    .font(Fonts.headline1)
                    .foregroundStyle(Colors.textDark)
                Text("\(L.MeteoriteInfoModal.recclass) \(viewModel.meteorite?.recclass ?? "")")
                    .font(Fonts.captions)
                    .foregroundStyle(Colors.textLight)
            }
            Spacer()
            // TODO: -- open Apple maps with coordinates
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
                Text(L.MeteoriteInfoModal.detailInfo)
                    .font(Fonts.body1)
                    .foregroundStyle(Colors.textDark)
                Spacer()
                Text("\(L.MeteoriteInfoModal.id): \(viewModel.meteorite?.id ?? L.Generic.unknown)")
                    .font(Fonts.body1)
                    .foregroundStyle(Colors.textLight)
            }
            Divider()
            VStack(spacing: Spacing.small) {
                detailInfoRow(L.MeteoriteInfoModal.distance, viewModel.getUserDistanceFromMeteorite())
                detailInfoRow(L.MeteoriteInfoModal.mass, viewModel.formattedMass(viewModel.meteorite?.mass))
                detailInfoRow(L.MeteoriteInfoModal.date, viewModel.meteorite?.year?.toFormattedDate(outputFormat: "d. MMMM yyyy"))
                detailInfoRow(L.MeteoriteInfoModal.coordinates, viewModel.getCoordinates())
            }
            .padding(.top, Padding.small)
        }
        .padding(.bottom, Padding.standard)
    }
    func detailInfoRow(_ label: String, _ value: String?) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value ?? L.Generic.unknown)
        }
        .foregroundStyle(Colors.textDark)
        .font(Fonts.captions)
    }
    var routeButton: PrimaryButton {
        PrimaryButton(
            icon: "location.north.circle",
            title: L.MeteoriteInfoModal.navigateToMeteorite,
            action: {
                // TODO: -- route to meteorite
            }
        )
    }
}

#Preview {
    MeteoriteInfoModalView(
        viewModel: MeteoriteInfoModalViewModel(
            meteorite: Meteorite.example
        )
    )
}
