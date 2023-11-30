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
    
    var route: MKRoute?
    var travelTime: String?
    
    init(
        viewModel: MapViewModel,
        route: MKRoute? = nil,
        travelTime: String? = nil
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.route = route
        self.travelTime = travelTime
        self._showNoMeteoritesAlert = State(
            initialValue: viewModel.geolocation?.latitude == "0.0" &&
            viewModel.geolocation?.longitude == "0.0" &&
            viewModel.nearestMeteorites == nil
        )
    }
    
    var body: some View {
        ZStack {
            Map(position: $position) {
                if let latitudeString = viewModel.geolocation?.latitude,
                   let longitudeString = viewModel.geolocation?.longitude,
                   let latitude = Double(latitudeString),
                   let longitude = Double(longitudeString) {
                    Annotation(
                        "",
                        coordinate: CLLocationCoordinate2D(
                            latitude: latitude,
                            longitude: longitude
                        )
                    ) {
                        meteoritePoint()
                    }
                }
                
                UserAnnotation()
                
                if let nearestMeteorites = viewModel.nearestMeteorites {
                    ForEach(nearestMeteorites, id: \.id) { meteorite in
                        if let latitudeString = meteorite.geolocation?.latitude,
                           let longitudeString = meteorite.geolocation?.longitude,
                           let latitude = Double(latitudeString),
                           let longitude = Double(longitudeString) {
                            Annotation(
                                "\(L.Map.meteorite) \(meteorite.name)",
                                coordinate: CLLocationCoordinate2D(
                                    latitude: latitude,
                                    longitude: longitude
                                )
                            ) {
                                Button(action: {
                                    viewModel.onSelectMeteorite(meteorite)
                                }) {
                                    meteoritePoint(meteorite)
                                }
                            }
                        }
                    }
                }
                
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 7)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .mapControlVisibility(.hidden)
            .alert(isPresented: $showNoMeteoritesAlert) {
                Alert(
                    title: Text(L.Map.alertTitle),
                    message: Text(L.Map.alertText),
                    dismissButton: .default(Text(L.Map.alertDismiss))
                )
            }
            .overlay(alignment: .top, content: {
                travelTimeLabel
            })
        }
        .overlay(
            actionRowView, alignment: .top
        )
        .onAppear {
            if showNoMeteoritesAlert {
                position = .userLocation(fallback: .automatic)
            }
        }
    }
}

private extension MapView {
    @ViewBuilder
    var travelTimeLabel: some View {
        if let travelTime {
            HStack {
                Text("\(L.Map.travelTime): \(travelTime)")
                    .font(Fonts.body1)
                    .foregroundStyle(Colors.black)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(CornerRadius.medium)
            .padding(.top, UIScreen.main.bounds.height / 10)
        }
    }
    var actionRowView: some View {
        VStack {
            HStack {
                actionCircleButton(
                    .systemName(Icons.arrowLeft)
                ) {
                    viewModel.goBackAction()
                }
                Spacer()
                Text(viewModel.title)
                    .font(Fonts.headline2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Padding.standard)
                Spacer()
                actionCircleButton(
                    .systemName(Icons.location)
                ) {
                    position = .userLocation(fallback: .automatic)
                }
            }
            if viewModel.nearestMeteorites == nil {
                HStack {
                    Spacer()
                    actionCircleButton(
                        .assetName(Icons.meteorite)
                    ) {
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
    func actionCircleButton(_ iconType: ButtonIconType, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Circle()
                .fill(Color.white)
                .frame(width: 50, height: 50)
                .shadow(color: Colors.black.opacity(0.1), radius: 2, x: 0, y: 2)
                .overlay(
                    Group {
                        switch iconType {
                        case .systemName(let image):
                            image
                                .imageScale(.large)
                                .foregroundColor(Color.black)
                        case .assetName(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35)
                        }
                    }
                )
        }
    }
    func meteoritePoint(_ meteorite: Meteorite? = nil) -> some View {
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
                .fill(meteorite != nil && viewModel.selectedMeteorite?.id == meteorite?.id ? Color.accentColor : Color.white)
                .frame(width: 50, height: 50)
                .overlay(
                    Icons.meteorite
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
            // nearestMeteorites: Meteorite.exampleList,
            goBackAction: {},
            onSelectMeteoriteAction: { _ in }
        )
    )
}
