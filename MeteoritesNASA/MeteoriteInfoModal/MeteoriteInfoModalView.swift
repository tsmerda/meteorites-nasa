//
//  MeteoriteInfoModalView.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import SwiftUI

struct MeteoriteInfoModalView: View {
    @StateObject private var viewModel: MeteoriteInfoModalViewModel
    var isNavigationOn: Bool
    
    init(
        viewModel: MeteoriteInfoModalViewModel,
        isNavigationOn: Bool = false
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.isNavigationOn = isNavigationOn
    }
    
    var body: some View {
        VStack {
            topLabelView
            meteoriteDetailView
            Spacer()
            routeButton
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
                    Icons.photo
                        .imageScale(.large)
                        .foregroundColor(Colors.textDark)
                )
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text(viewModel.meteorite?.name ?? "")
                    .font(Fonts.headline1)
                    .foregroundStyle(Colors.textDark)
                Text(L.MeteoriteInfoModal.recclass + ": " + (viewModel.meteorite?.recclass ?? L.Generic.unknown))
                    .font(Fonts.captions)
                    .foregroundStyle(Colors.textLight)
            }
            Spacer()
            Button(action: {
                viewModel.openInMaps()
            }) {
                HStack{
                    Text(L.MeteoriteInfoModal.openInMaps)
                        .foregroundStyle(Colors.textLight)
                        .font(Fonts.captions)
                        .frame(width: 60)
                        .multilineTextAlignment(.leading)
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Icons.map
                                .imageScale(.large)
                                .foregroundColor(Colors.black)
                        )
                }
            }
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
                detailInfoRow(L.MeteoriteInfoModal.mass, viewModel.getFormattedMass())
                detailInfoRow(L.MeteoriteInfoModal.date, viewModel.getFormattedYear())
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
    @ViewBuilder
    var routeButton: PrimaryButton? {
        if viewModel.withRouteButton {
            PrimaryButton(
                icon: !isNavigationOn ? Icons.locationOn : Icons.locationOff,
                title: !isNavigationOn ? L.MeteoriteInfoModal.navigateToMeteorite : L.MeteoriteInfoModal.cancelNavigation,
                action: {
                    !isNavigationOn ? viewModel.onNavigate() : viewModel.onCancelNavigation()
                },
                color: !isNavigationOn ? Color.accentColor : Colors.warning
            )
        }
    }
}

#Preview {
    MeteoriteInfoModalView(
        viewModel: MeteoriteInfoModalViewModel(
            meteorite: Meteorite.example,
            onNavigateAction: {},
            onCancelNavigationAction: {}
        )
    )
}
