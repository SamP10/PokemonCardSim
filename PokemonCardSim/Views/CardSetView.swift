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
    @State private var zindex: Double = 0;
    @State private var offset = CGSize.zero
    @State private var cardPack: [PokemonCard] = []
    @State private var setId: String;
    @State private var shouldLoad: Bool = false;
    
    init(setId: String) {
        self.setId = setId;
        self.cardService = PokemonCardService(setId: setId)
    }

    var body: some View {
        VStack{
            if(self.cardService.isLoading || self.imageService.isLoading) && self.shouldLoad {
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
            if !self.shouldLoad {
                self.shouldLoad = true
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
}
