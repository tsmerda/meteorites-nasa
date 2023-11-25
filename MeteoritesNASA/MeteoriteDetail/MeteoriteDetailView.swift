//
//  MeteoriteDetailView.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import SwiftUI
import MapKit

struct MeteoriteDetailView: View {
    @StateObject private var viewModel: MeteoriteDetailViewModel
    @EnvironmentObject var nav: NavigationStateManager
    @State private var showMeteoriteDetail: Bool = true
    private let progressHudBinding: ProgressHudBinding
    
    init(viewModel: MeteoriteDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.progressHudBinding = ProgressHudBinding(state: viewModel.$progressHudState)
    }
    
    var body: some View {
        VStack {
            mapView
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden()
        .overlay(
            actionRowView, alignment: .topLeading
        )
        .sheet(isPresented: $showMeteoriteDetail) {
            meteoriteInfoModalView
        }
    }
}

// TODO: -- calculate my distance from this meteorite
private extension MeteoriteDetailView {
    var actionRowView: some View {
        HStack {
            actionCircleButton("arrow.left") {
                nav.goBack()
            }
            Spacer()
            Text("Meteorite \(viewModel.meteorite.name)")
                .font(Fonts.headline2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Padding.standard)
            Spacer()
            actionCircleButton("location") {
                debugPrint("Show my location")
            }
        }
        .padding()
    }
    @ViewBuilder
    var mapView: some View {
        if let geolocation = viewModel.meteorite.geolocation {
            let mapViewModel = MapViewModel(geolocation: geolocation)
                MapView(viewModel: mapViewModel)
        }
    }
    var meteoriteInfoModalView: some View {
        MeteoriteInfoModalView(
            viewModel: MeteoriteInfoModalViewModel(
                meteorite: viewModel.meteorite
            )
        )
        .presentationDetents([.height(230), .medium])
        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        .interactiveDismissDisabled()
        .presentationDragIndicator(.automatic)
    }
    func actionCircleButton(_ icon: String, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Circle()
                .fill(Color.white)
                .frame(width: 50, height: 50)
                .shadow(color: Colors.black.opacity(0.1), radius: 2, x: 0, y: 2)
                .overlay(
                    Image(systemName: icon)
                        .imageScale(.large)
                        .foregroundColor(Color.accentColor)
                )
        }
    }
}

#Preview {
    MeteoriteDetailView(
        viewModel: MeteoriteDetailViewModel(
            meteorite: Meteorite.example
        )
    )
}
