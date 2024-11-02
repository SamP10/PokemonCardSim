//
//  RandomPackService.swift
//  PokemonCardSim
//
//  Created by Sam Plant on 27/10/2024.
//

import SwiftUI

class RandomPackService: ObservableObject {
    typealias Pack = [PokemonCard];
    @Published var totalAmount: String = "";
    
    public func getRandomPack(cardsByRarity: PokemonCardsByRarity) -> Pack {
        var pack: Pack = []
         
        self.getRandomCards(
            numberOfCards: 5,
            cards: cardsByRarity[cardRarity.common] ?? [],
            pack: &pack
        )
    
        self.getRandomCards(
            numberOfCards: 4,
            cards: cardsByRarity[cardRarity.uncommon] ?? [],
            pack: &pack
        )
        
        var cardRarities: [cardRarity] = Array(cardsByRarity.keys)
        cardRarities.removeAll { value in
            return value == cardRarity.common || value == cardRarity.uncommon
        }
        
        self.getRandomCards(
            numberOfCards: 1,
            cards: cardsByRarity[cardRarities.randomElement() ?? cardRarity.uncommon] ?? [],
            pack: &pack
        )
        
        calculateTotal(pack: pack);
        return pack
    }
    
    private func getRandomCards(numberOfCards: Int, cards: [PokemonCard], pack: inout Pack) -> Void {
        for _ in 1...numberOfCards {
            var card = cards.randomElement()!;
            if(pack.contains(card)) {
                while (pack.contains(card)){
                    card = cards.randomElement()!
                }
            }
            pack.append(card)
        }
    }
    
    private func calculateTotal(pack: Pack) -> Void {
        var total: Double = 0.00
        for card in pack {
            total += card.cardmarket.prices.averageSellPrice
        }
        self.totalAmount = String(format: "%.2f", total)
    }
}
