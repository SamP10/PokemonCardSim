//
//  RotatingImageView.swift
//  PokemonCardSim
//
//  Created by Sam Plant on 02/11/2024.
//
import SwiftUI

struct RotatingImageView: View {
    let imageName: String
    let size: CGFloat
    @State private var rotationAngle: Double = 0

    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotationAngle))
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    self.rotationAngle += 360
                }
            }
            .zIndex(0)
    }
}
