//
//  CardSetView.swift
//  PokemonCardSim
//
//  Created by Sam Plant on 28/10/2024.
//

import SwiftUI
import CoreData
import UIKit
import SwiftUI

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
        ZStack{
            Image("Background")
                .resizable()
                .scaledToFill()
                .offset(x:-10, y:-1)
            if(self.cardService.isLoading || self.imageService.isLoading) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 9)
                            .fill(.white)
                    )
            } else {
                PackView(cardsByRarity: cardService.cardsByRarity, imageService: imageService)
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
