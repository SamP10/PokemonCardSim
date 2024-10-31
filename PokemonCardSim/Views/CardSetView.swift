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
    @State private var cardService: PokemonCardService;
    @State private var cardPack: [PokemonCard] = []
    @State private var setId: String;
    
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
                ZStack {
                    Image("Background")
                        .resizable()
                        .scaledToFill()
                    
                    PackView(cardsByRarity: cardService.cardsByRarity, imageService: imageService)
                }
            }
        }
        .onAppear() {
            Task {
                await self.cardService.fetchPokemonCards()
                await self.imageService.loadImages(cards: self.cardService.cards)
            }
        }
    }
}
