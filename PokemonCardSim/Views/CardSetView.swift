//
//  CardSetView.swift
//  PokemonCardSim
//
//  Created by Sam Plant on 28/10/2024.
//

import SwiftUI
import CoreData
import UIKit

struct CardSetView: View {
    @StateObject private var imageService: ImageService = ImageService()
    @StateObject private var packService: RandomPackService = RandomPackService()
    @State private var cardService: PokemonCardService;
    @State private var cardPack: [PokemonCard] = []
    @State private var setId: String;
    @State private var zIndex: Double = 0;
    @State private var rotationOffset: CGSize = .zero;
    
    init(setId: String) {
        self.setId = setId;
        self.cardService = PokemonCardService(setId: setId)
    }

    var body: some View {
        VStack{
            if(self.cardService.isLoading || self.imageService.isLoading) {
                ProgressView()
                    .frame(width: 50, height: 50)
            } else {
                ZStack{
                    Image("Background")
                        .resizable()
                        .scaledToFill()
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
            }
        }
        .onAppear() {
            Task {
                await self.cardService.fetchPokemonCards()
                await self.imageService.loadImages(cards: self.cardService.cards)
                
                DispatchQueue.main.async {
                    self.cardPack = packService.getRandomPack(cardsByRarity: cardService.cardsByRarity)
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
