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
    @State private var allCardsRevealed: Bool = false;
    
    init(cardsByRarity: PokemonCardsByRarity, imageService: ImageService) {
        self.cardsByRarity = cardsByRarity;
        self.imageService = imageService;
    }

    var body: some View {
        ZStack{
            if(!allCardsRevealed) {
                PackOpener(pack: self.cardPack, imageService: self.imageService, allCardsRevealed: $allCardsRevealed)
            } else {
                Transition()
            }
            
        }
        .onAppear() {
            Task {
                DispatchQueue.main.async {
                    self.cardPack = packService.getRandomPack(cardsByRarity: self.cardsByRarity)
                }
            }
        }
    }
}
