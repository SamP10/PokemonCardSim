//
//  PackOpener.swift
//  PokemonCardSim
//
//  Created by Sam Plant on 31/10/2024.
//

import SwiftUI
import CoreData
import UIKit

struct PackOpener: View {
    @State private var imageService: CardImageService;
    @State private var cardPack: [PokemonCard] = [];
    @State private var zIndex: Double = 0;
    @State private var rotationOffset: CGSize = .zero;
    @State private var revealedCards: [PokemonCard] = [];
    @Binding var allCardsRevealed: Bool;
    private var pack: [PokemonCard];
    
    init(pack: [PokemonCard], imageService: CardImageService, allCardsRevealed: Binding<Bool>) {
        self.pack = pack;
        self.imageService = imageService;
        self._allCardsRevealed = allCardsRevealed;
    }

    var body: some View {
        ZStack{
            ForEach(self.pack.reversed(), id: \.id) { card in
                CardImageView(uiImage: self.imageService.cardByImage[card] ?? UIImage()){
                    self.zIndex += 1
                    revealedCards.append(card);
                    
                    if(revealedCards.count == self.pack.count) {
                        self.allCardsRevealed = true;
                    }
                    
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
                axis: (x: 1, y: 0, z: 2)
            )
            .rotation3DEffect(
                self.offset2Angle(true),
                axis: (x: 0, y: 1, z: 2)
            )
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
