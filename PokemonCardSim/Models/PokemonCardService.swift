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
        cardRarity.common: [],
        cardRarity.uncommon: [],
        cardRarity.rare: [],
        cardRarity.rareHolo: []
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
            switch card.rarity {
            case "Common":
                self.cardsByRarity[cardRarity.common]?.append(card);
            case "Uncommon":
                self.cardsByRarity[cardRarity.uncommon]?.append(card);
            case "Rare":
                self.cardsByRarity[cardRarity.rare]?.append(card);
            case "Rare Holo":
                self.cardsByRarity[cardRarity.rareHolo]?.append(card);
            default:
                self.cardsByRarity[cardRarity.common]?.append(card);
            }
        }
    }
}

struct PokemonCardResponse: Decodable {
    let data: [PokemonCard]
}
