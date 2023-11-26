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
    
    init(viewModel: MapViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Map(position: $position) {
                Annotation(
                    "",
                    coordinate: CLLocationCoordinate2D(
                        latitude: viewModel.geolocation.coordinates[1],
                        longitude: viewModel.geolocation.coordinates[0]
                    )
                ) {
                    meteoritePoint
                }
                UserAnnotation()
            }
            .edgesIgnoringSafeArea(.all)
            .mapControlVisibility(.hidden)
        }
        .overlay(
            actionRowView, alignment: .topLeading
        )
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
                Text("Meteorite \(viewModel.title)")
                    .font(Fonts.headline2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Padding.standard)
                Spacer()
                actionCircleButton("location.fill") {
                    position = .userLocation(fallback: .automatic)
                }
            }
            HStack {
                Spacer()
                actionCircleButton("scalemass.fill") {
                    position = .item(
                        viewModel.getMeteoritePosition()
                    )
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
            goBackAction: {})
    )
}
