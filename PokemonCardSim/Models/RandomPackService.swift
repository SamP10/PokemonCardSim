//
//  RandomPackService.swift
//  PokemonCardSim
//
//  Created by Sam Plant on 27/10/2024.
//

import SwiftUI

class RandomPackService: ObservableObject {
    typealias Pack = [PokemonCard];
    
    public func getRandomPack(cardsByRarity: PokemonCardsByRarity) -> Pack {
        var pack: Pack = []
        
        for rarity in cardsByRarity.keys {
            if(pack.count == 10) {
                break;
            }
            
            switch rarity {
            case cardRarity.common:
                pack.append(
                    contentsOf: self.getRandomCards(
                        numberOfCards: 4,
                        cards: cardsByRarity[cardRarity.common]!
                    )
                )
            case cardRarity.uncommon:
                pack.append(
                    contentsOf: self.getRandomCards(
                        numberOfCards: 3,
                        cards: cardsByRarity[cardRarity.uncommon]!
                    )
                )
            case cardRarity.rare:
                pack.append(
                    contentsOf: self.getRandomCards(
                        numberOfCards: 2,
                        cards: cardsByRarity[cardRarity.rare]!
                    )
                )
            case cardRarity.rareHolo:
                pack.append(
                    contentsOf: self.getRandomCards(
                        numberOfCards: 1,
                        cards: cardsByRarity[cardRarity.rareHolo]!
                    )
                )
            default:
                continue;
            }
        }
        
        return pack
    }
    
    private func getRandomCards(numberOfCards: Int, cards: [PokemonCard]) -> [PokemonCard] {
        var cardsToReturn: [PokemonCard]  = []
        
        if(cards.isEmpty) {
            return cardsToReturn
        }
        
        for _ in 1...numberOfCards {
            cardsToReturn.append(cards.randomElement()!)
        }
        return cardsToReturn
    }
}
