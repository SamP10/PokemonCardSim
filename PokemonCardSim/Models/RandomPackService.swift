//
//  RandomPackService.swift
//  PokemonCardSim
//
//  Created by Sam Plant on 27/10/2024.
//

import SwiftUI

class RandomPackService: ObservableObject {
    typealias Pack = [PokemonCard];
    @Published var totalAmount: Double = 0.00;
    
    public func getRandomPack(cardsByRarity: PokemonCardsByRarity) -> Pack {
        var pack: Pack = []
        
        for rarity in cardsByRarity.keys {
            let numberOfCardsInPack = pack.count;
            
            if(numberOfCardsInPack >= 10) {
                break;
            }
            
            switch rarity {
            case cardRarity.common:
                let numberOfCards = 5;
                self.getRandomCards(
                    numberOfCards: numberOfCards,
                    cards: cardsByRarity[cardRarity.common]!,
                    pack: &pack
                )
            case cardRarity.uncommon:
                let numberOfCards = 4;
                self.getRandomCards(
                    numberOfCards: numberOfCards,
                    cards: cardsByRarity[cardRarity.uncommon]!,
                    pack: &pack
                )
            default:
                var cardRarities: [cardRarity] = Array(cardsByRarity.keys)
                cardRarities.removeAll { value in
                    return value == cardRarity.common || value == cardRarity.uncommon
                }
                self.getRandomCards(
                    numberOfCards: 1,
                    cards: cardsByRarity[cardRarities.randomElement()!]!,
                    pack: &pack
                )
            }
        }
        
        calculateTotal(pack: pack);
        return pack
    }
    
    private func getRandomCards(numberOfCards: Int, cards: [PokemonCard], pack: inout Pack) {
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
        self.totalAmount = 0.00
        for card in pack {
            self.totalAmount += card.cardmarket.prices.averageSellPrice
        }
    }
}
