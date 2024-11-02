//
//  CardModel.swift
//  PokemonCardPackSimualator
//
//  Created by Sam Plant on 22/10/2024.
//

import Foundation

struct PokemonCard: Identifiable, Decodable, Equatable, Hashable  {
    public var id: String
    public var name: String
    public var images: Images
    public var cardmarket: CardMarket
    public var rarity: String?
   
    public struct Images: Decodable, Equatable, Hashable  {
            var small: String?
            var large: String?
        }
    
    public struct CardMarket: Decodable, Equatable, Hashable  {
        var prices: Prices
        
        struct Prices: Decodable, Equatable, Hashable  {
            var  averageSellPrice: Double
            var  lowPrice: Double
            var  trendPrice: Double
            var  suggestedPrice: Double
            var  avg1: Double
            var  avg7: Double
            var  avg30: Double
        }
    }
}

typealias PokemonCardsByRarity = [cardRarity: [PokemonCard]];
