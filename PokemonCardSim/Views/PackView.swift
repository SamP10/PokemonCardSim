//
//  PackView.swift
//  PokemonCardSim
//
//  Created by Sam Plant on 31/10/2024.
//

import SwiftUI
import CoreData
import UIKit

struct PackView: View {
    @StateObject private var packService: RandomPackService = RandomPackService()
    @State private var imageService: ImageService;
    @State private var cardsByRarity: PokemonCardsByRarity;
    @State private var cardPack: [PokemonCard] = [];
    @State private var zIndex: Double = 0;
    @State private var rotationOffset: CGSize = .zero;
    
    init(cardsByRarity: PokemonCardsByRarity, imageService: ImageService) {
        self.cardsByRarity = cardsByRarity;
        self.imageService = imageService;
    }

    var body: some View {
        ZStack{
            ForEach(self.cardPack.reversed(), id: \.id) { card in
                CardImageView(uiImage: self.imageService.cardByImage[card] ?? UIImage()){
                    self.zIndex += 1
                    return self.zIndex
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.rotationOffset = value.translation
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
                axis: (x: 10, y: 0, z: 2)
            )
            .rotation3DEffect(
                self.offset2Angle(true),
                axis: (x: 0, y: 1, z: 2)
            )
        }
        .onAppear() {
            Task {
                DispatchQueue.main.async {
                    self.cardPack = packService.getRandomPack(cardsByRarity: self.cardsByRarity)
                }
            }
        }
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
