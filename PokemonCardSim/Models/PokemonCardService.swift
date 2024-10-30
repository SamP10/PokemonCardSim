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
    @Published var cardsByRarity: PokemonCardsByRarity = [
        cardRarity.amazingRare: [],
        cardRarity.common: [],
        cardRarity.LEGEND: [],
        cardRarity.promo: [],
        cardRarity.rare: [],
        cardRarity.rareACE: [],
        cardRarity.rareBREAK: [],
        cardRarity.rareHolo: [],
        cardRarity.rareHoloEX: [],
        cardRarity.rareHoloGX: [],
        cardRarity.rareHoloLVX: [],
        cardRarity.rareHoloStar: [],
        cardRarity.rareHoloV: [],
        cardRarity.rareHoloVMAX: [],
        cardRarity.rarePrime: [],
        cardRarity.rarePrismStar: [],
        cardRarity.rareRainbow: [],
        cardRarity.rareSecret: [],
        cardRarity.rareShining: [],
        cardRarity.rareShiny: [],
        cardRarity.rareShinyGX: [],
        cardRarity.rareUltra: [],
        cardRarity.uncommon: []
    ];
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
                self.cardsByRarity[cardRarity.amazingRare]?.append(card)
            case "common":
                self.cardsByRarity[cardRarity.common]?.append(card)
            case "legend":
                self.cardsByRarity[cardRarity.LEGEND]?.append(card)
            case "promo":
                self.cardsByRarity[cardRarity.promo]?.append(card)
            case "rare":
                self.cardsByRarity[cardRarity.rare]?.append(card)
            case "rare ace":
                self.cardsByRarity[cardRarity.rareACE]?.append(card)
            case "rare break":
                self.cardsByRarity[cardRarity.rareBREAK]?.append(card)
            case "rare holo":
                self.cardsByRarity[cardRarity.rareHolo]?.append(card)
            case "rare holo ex":
                self.cardsByRarity[cardRarity.rareHoloEX]?.append(card)
            case "rare holo gx":
                self.cardsByRarity[cardRarity.rareHoloGX]?.append(card)
            case "rare holo lvx":
                self.cardsByRarity[cardRarity.rareHoloLVX]?.append(card)
            case "rare holo star":
                self.cardsByRarity[cardRarity.rareHoloStar]?.append(card)
            case "rare holo v":
                self.cardsByRarity[cardRarity.rareHoloV]?.append(card)
            case "rare holo vmax":
                self.cardsByRarity[cardRarity.rareHoloVMAX]?.append(card)
            case "rare prime":
                self.cardsByRarity[cardRarity.rarePrime]?.append(card)
            case "rare prism star":
                self.cardsByRarity[cardRarity.rarePrismStar]?.append(card)
            case "rare rainbow":
                self.cardsByRarity[cardRarity.rareRainbow]?.append(card)
            case "rare secret":
                self.cardsByRarity[cardRarity.rareSecret]?.append(card)
            case "rare shining":
                self.cardsByRarity[cardRarity.rareShining]?.append(card)
            case "rare shiny":
                self.cardsByRarity[cardRarity.rareShiny]?.append(card)
            case "rare shiny gx":
                self.cardsByRarity[cardRarity.rareShinyGX]?.append(card)
            case "rare ultra":
                self.cardsByRarity[cardRarity.rareUltra]?.append(card)
            case "uncommon":
                self.cardsByRarity[cardRarity.uncommon]?.append(card)
            default:
                self.cardsByRarity[cardRarity.common]?.append(card);
            }
        }
    }
}

struct PokemonCardResponse: Decodable {
    let data: [PokemonCard]
}
