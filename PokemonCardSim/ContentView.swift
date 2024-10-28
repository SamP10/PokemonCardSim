//
//  ContentView.swift
//  PokemonCardPackSimualator
//
//  Created by Sam Plant on 24/10/2024.
//

import SwiftUI
import CoreData
import UIKit

struct PokemonCardSetView: View {
    @StateObject var cardService = PokemonCardService(setId: "Base1")
    @StateObject var imageService: ImageService = ImageService()
    @StateObject var packService: RandomPackService = RandomPackService()
    @State private var zindex: Double = 0;
    @State private var offset = CGSize.zero
    @State var cardPack: [PokemonCard] = []

    var body: some View {
        VStack{
            if(self.cardService.isLoading || self.imageService.isLoading) {
                ProgressView()
                    .frame(width: 50, height: 50)
            } else {
                ZStack{
                    ForEach(self.cardPack.reversed()) { card in
                        if let loadedImage = self.imageService.cardByImage[card] {
                            ImageView(uiImage: loadedImage)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 200)
                                .offset(self.offset)
                                .onTapGesture {
                                    self.offset = CGSize(width: 200, height: 0)
                                    self.zindex = 1
                                }
                                .animation(.bouncy, value: offset)
                                .zIndex(self.zindex)
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
                    self.cardPack = packService.getRandomPack(cardsByRarity: cardService.cardsByRarity);
                }
            }
        }
    }
}

#Preview{
    PokemonCardSetView()
}

