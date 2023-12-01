//
//  NearestMeteoritesDetailView.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 26.11.2023.
//

import SwiftUI
import MapKit

struct NearestMeteoritesDetailView: View {
    @StateObject private var viewModel: NearestMeteoritesDetailViewModel
    
    @EnvironmentObject var nav: NavigationStateManager
    
    @State private var showMeteoriteDetail: Bool = false
    @State private var isAnimating: Bool = false
    
    private let progressHudBinding: ProgressHudBinding
    
    init(viewModel: NearestMeteoritesDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.progressHudBinding = ProgressHudBinding(
            state: viewModel.$progressHudState
        )
    }
    
    var body: some View {
        VStack {
            mapView
        }
        .overlay(infoLabel, alignment: .bottom)
        .navigationBarBackButtonHidden()
        .sheet(
            isPresented: $showMeteoriteDetail,
            onDismiss: {
                viewModel.selectedMeteorite = nil
                withAnimation(.linear(duration: 0.5)) {
                    isAnimating = true
                }
            }) {
                meteoriteInfoModalView
            }
            .onAppear(perform: {
                withAnimation(.linear(duration: 0.5)) {
                    isAnimating = true
                }
            })
    }
}

private extension NearestMeteoritesDetailView {
    @ViewBuilder
    var infoLabel: some View {
        if viewModel.selectedMeteorite == nil {
            HStack(spacing: Spacing.small) {
                Icons.dotCircleAndHand
                    .foregroundColor(Colors.textDark)
                Text(L.NearestMeteoritesDetail.infoLabel)
                    .font(Fonts.body1)
                    .foregroundStyle(Colors.textDark)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(CornerRadius.medium)
            .opacity(isAnimating ? 1 : 0)
            .padding(.horizontal)
            .padding(.bottom, UIScreen.main.bounds.height / 12)
            .animation(.linear(duration: 0.5), value: isAnimating)
        }
    }
    @ViewBuilder
    var mapView: some View {
        let mapViewModel = MapViewModel(
            title: L.NearestMeteoritesDetail.nearestMeteorites,
            nearestMeteorites: viewModel.meteorites,
            goBackAction: { nav.goBack() },
            onSelectMeteoriteAction: {
                withAnimation(.linear(duration: 0.5)) {
                    isAnimating = false
                }
                viewModel.selectedMeteorite = $0
                showMeteoriteDetail = true
            },
            locationManager: viewModel.locationManager
        )
        MapView(
            viewModel: mapViewModel,
            route: viewModel.route,
            travelTime: viewModel.travelTime
        )
    }
    var meteoriteInfoModalView: some View {
        MeteoriteInfoModalView(
            viewModel: MeteoriteInfoModalViewModel(
                meteorite: viewModel.selectedMeteorite,
                withRouteButton: true,
                onNavigateAction: {
                    Task {
                        await viewModel.fetchRoute()
                    }
                },
                onCancelNavigationAction: {
                    viewModel.cancelRoute()
                },
                locationManager: viewModel.locationManager
            ),
            isNavigationOn: viewModel.route != nil
        )
        .id(viewModel.selectedMeteorite?.id)
        .presentationDetents([.height(330), .medium])
        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        .presentationDragIndicator(.automatic)
    }
}

#Preview {
    NearestMeteoritesDetailView(
        viewModel: NearestMeteoritesDetailViewModel(
            meteorites: Meteorite.exampleList,
            locationManager: MockLocationManager()
        )
    )
}
