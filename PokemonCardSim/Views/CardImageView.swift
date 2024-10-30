//
//  ImageView.swift
//  PokemonCardPackSim
//
//  Created by Sam Plant on 22/10/2024.
//

import SwiftUI
import Combine
import UIKit

struct CardImageView: View {
    @State private var offset = CGSize.zero
    @State private var zIndex: Double = 0;
    @State private var rotationOffset: CGSize = .zero;
    private var uiImage: UIImage;
    var onTap: (() -> Double);

    
    init(uiImage: UIImage, onTap: (() -> Double)? = nil) {
        self.uiImage = uiImage
        self.onTap = (onTap)!;
    }
    
    var body: some View {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200)
                .offset(self.offset)
                .onTapGesture {
                    self.zIndex = onTap()
                    withAnimation(.smooth) {
                        self.offset = CGSize(width: 250, height: 0)
                    }
                }
                .zIndex(self.zIndex)
                .gesture(
                        DragGesture()
                            .onChanged { value in
                                if(self.offset == .zero) {
                                    self.rotationOffset = value.translation
                                }
                            }
                            .onEnded { _ in
                                withAnimation(
                                    .interactiveSpring(
                                        response: 0.6,
                                        dampingFraction: 0.32,
                                        blendDuration: 0.32))
                                {
                                    self.rotationOffset = .zero
                                }
                            }
                    )
                .rotation3DEffect(
                    self.offset2Angle(),
                    axis: (x: 1, y: 0, z: 1)
                )
                .rotation3DEffect(
                    self.offset2Angle(true),
                    axis: (x: 0, y: 1, z: 1)
                )
    }
    
    func offset2Angle(_ isVerticle: Bool = false) -> Angle {
        let degree = (isVerticle ? self.rotationOffset.height : self.rotationOffset.width) /
            (isVerticle ? self.screenSize.height : self.screenSize.width)
        return .init(degrees: degree * 20)
    }
    
    var screenSize: CGSize = {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else {
            return .zero
        }
        
        return window.screen.bounds.size
    }()
}
