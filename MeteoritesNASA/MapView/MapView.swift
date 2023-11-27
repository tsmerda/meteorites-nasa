//
//  MapView.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel: MapViewModel
    @State private var animationScale = 1.0
    @State private var position: MapCameraPosition = .automatic
    @State private var showNoMeteoritesAlert = false
    
    init(viewModel: MapViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._showNoMeteoritesAlert = State(
            initialValue: viewModel.geolocation?.coordinates[1] == 0 &&
            viewModel.geolocation?.coordinates[0] == 0 &&
            viewModel.nearestMeteorites == nil
        )
    }
    
    var body: some View {
        ZStack {
            Map(position: $position) {
                if let latitude = viewModel.geolocation?.coordinates[1],
                   let longitude = viewModel.geolocation?.coordinates[0] {
                    Annotation(
                        "",
                        coordinate: CLLocationCoordinate2D(
                            latitude: latitude,
                            longitude: longitude
                        )
                    ) {
                        meteoritePoint
                    }
                }
                
                UserAnnotation()
                
                if let nearestMeteorites = viewModel.nearestMeteorites {
                    ForEach(nearestMeteorites, id: \.id) { meteorite in
                        if let latitude = meteorite.geolocation?.coordinates[1],
                           let longitude = meteorite.geolocation?.coordinates[0] {
                            Annotation(
                                "Meteorit \(meteorite.name)",
                                coordinate: CLLocationCoordinate2D(
                                    latitude: latitude,
                                    longitude: longitude
                                )
                            ) {
                                Button(action: {
                                    // TODO: -- fix optional
                                    viewModel.onSelectMeteoriteAction!(meteorite)
                                }) {
                                    meteoritePoint
                                }
                            }
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .mapControlVisibility(.hidden)
            .alert(isPresented: $showNoMeteoritesAlert) {
                Alert(
                    title: Text("Upozornění"),
                    message: Text("Nejsou k dispozici žádné meteority."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .overlay(
            actionRowView, alignment: .topLeading
        )
        .onAppear {
            if showNoMeteoritesAlert {
                position = .userLocation(fallback: .automatic)
            }
        }
    }
}

private extension MapView {
    var actionRowView: some View {
        VStack {
            HStack {
                actionCircleButton("arrow.left") {
                    viewModel.goBackAction()
                }
                Spacer()
                Text(viewModel.title)
                    .font(Fonts.headline2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Padding.standard)
                Spacer()
                actionCircleButton("location.fill") {
                    position = .userLocation(fallback: .automatic)
                }
            }
            if viewModel.nearestMeteorites == nil {
                HStack {
                    Spacer()
                    actionCircleButton("scalemass.fill") {
                        if let meteoritePosition = viewModel.getMeteoritePosition() {
                            position = .item(
                                meteoritePosition
                            )
                        }
                    }
                }
            }
        }
        .padding()
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
    var meteoritePoint: some View {
        ZStack {
            Circle()
                .stroke(Color.accentColor.opacity(0.4), lineWidth: 2)
                .frame(width: 62, height: 62)
                .scaleEffect(animationScale)
                .opacity(2 - animationScale)
                .animation(
                    .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: false),
                    value: animationScale)
            Circle()
                .stroke(Color.accentColor.opacity(0.4), lineWidth: 2)
                .frame(width: 62, height: 62)
            
            Circle()
                .stroke(Color.accentColor, lineWidth: 4)
                .fill(Color.white)
                .frame(width: 50, height: 50)
                .overlay(
                    Image("meteorite-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                )
        }
        .onAppear {
            animationScale = 2
        }
    }
}

#Preview {
    MapView(
        viewModel: MapViewModel(
            title: "Title",
            geolocation: Geolocation.example,
            goBackAction: {},
            onSelectMeteoriteAction: { _ in }
        )
    )
}
