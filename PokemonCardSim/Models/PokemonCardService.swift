//
//  PokemonCardView.swift
//  PokemonCardPackSimualator
//
//  Created by Sam Plant on 22/10/2024.
//

import Foundation
import Combine
import SwiftUI

class PokemonCardService: ObservableObject {
    @State var setId: String;
    @Published var cardsByRarity: PokemonCardsByRarity = [:];
    @Published var cards: [PokemonCard] = []
    @Published var isLoading: Bool = true;
    
    init(setId: String) {
        self.setId = setId
    }

    func fetchPokemonCards() async {
        if(!cards.isEmpty) {
            return;
        }
        
        let apiKey = ProcessInfo.processInfo.environment["apiKey"]
        let urlString = "https://api.pokemontcg.io/v2/cards?q=set.id:\"\(setId)\""

        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error with status code: \(response)")
                return
            }
            
            let decodedResponse = try JSONDecoder().decode(PokemonCardResponse.self, from: data)
            
            DispatchQueue.main.async { [weak self] in
                self!.cards = decodedResponse.data
                self!.categoriseCards(cards: decodedResponse.data)
            }
            
        } catch {
            print("Error fetching cards: \(error.localizedDescription)")
        }
        DispatchQueue.main.async { [weak self] in
            self?.isLoading.toggle()
        }
    }
        
    func categoriseCards(cards: [PokemonCard]) {
        for card in cards {
            switch card.rarity?.lowercased() {
            case "amazing rare":
                self.addCard(card: card, rarity: cardRarity.amazingRare)
            case "common":
                self.addCard(card: card, rarity: cardRarity.common)
            case "legend":
                self.addCard(card: card, rarity: cardRarity.LEGEND)
            case "promo":
                self.addCard(card: card, rarity: cardRarity.promo)
            case "rare":
                self.addCard(card: card, rarity: cardRarity.rare)
            case "rare ace":
                self.addCard(card: card, rarity: cardRarity.rareACE)
            case "rare break":
                self.addCard(card: card, rarity: cardRarity.rareBREAK)
            case "rare holo":
                self.addCard(card: card, rarity: cardRarity.rareHolo)
            case "rare holo ex":
                self.addCard(card: card, rarity: cardRarity.rareHoloEX)
            case "rare holo gx":
                self.addCard(card: card, rarity: cardRarity.rareHoloGX)
            case "rare holo lv.x":
                self.addCard(card: card, rarity: cardRarity.rareHoloLVX)
            case "rare holo star":
                self.addCard(card: card, rarity: cardRarity.rareHoloStar)
            case "rare holo v":
                self.addCard(card: card, rarity: cardRarity.rareHoloV)
            case "rare holo vmax":
                self.addCard(card: card, rarity: cardRarity.rareHoloVMAX)
            case "rare prime":
                self.addCard(card: card, rarity: cardRarity.rarePrime)
            case "rare prism star":
                self.addCard(card: card, rarity: cardRarity.rarePrismStar)
            case "rare rainbow":
                self.addCard(card: card, rarity: cardRarity.rareRainbow)
            case "rare secret":
                self.addCard(card: card, rarity: cardRarity.rareSecret)
            case "rare shining":
                self.addCard(card: card, rarity: cardRarity.rareShining)
            case "rare shiny":
                self.addCard(card: card, rarity: cardRarity.rareShiny)
            case "rare shiny gx":
                self.addCard(card: card, rarity: cardRarity.rareShinyGX)
            case "rare ultra":
                self.addCard(card: card, rarity: cardRarity.rareUltra)
            case "uncommon":
                self.addCard(card: card, rarity: cardRarity.uncommon)
            default:
                self.addCard(card: card, rarity: cardRarity.common)
            }
        }
    }
    
    func addCard(card: PokemonCard, rarity: cardRarity) {
        self.cardsByRarity[rarity] == nil ?
            self.cardsByRarity[rarity] = [] :
            self.cardsByRarity[rarity]?.append(card);
    }
}

struct PokemonCardResponse: Decodable {
    let data: [PokemonCard]
}
