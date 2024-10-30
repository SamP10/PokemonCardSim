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
                    ForEach(self.cardPack.reversed(), id: \.id) { card in
                        CardImageView(uiImage: self.imageService.cardByImage[card] ?? UIImage()){
                            self.zIndex += 1
                            return self.zIndex
                        }
                    }
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
}
