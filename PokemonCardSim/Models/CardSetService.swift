//
//  CardSetService.swift
//  PokemonCardSim
//
//  Created by Sam Plant on 28/10/2024.
//

import Foundation
import Combine
import SwiftUI

class CardSetService: ObservableObject {
    @Published var sets: [PokemonCardSet] = []
    @Published var isLoading: Bool = true;

    func fetchPokemonCards() async {
        let urlString = "https://api.pokemontcg.io/v2/sets"
        let apiKey = ProcessInfo.processInfo.environment["apiKey"]

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
            
            let decodedResponse = try JSONDecoder().decode(CardSetResponse.self, from: data)
            
            DispatchQueue.main.async { [weak self] in
                self!.sets = decodedResponse.data
            }
            
        } catch {
            print("Error fetching cards: \(error.localizedDescription)")
        }
        DispatchQueue.main.async { [weak self] in
            self?.isLoading.toggle()
        }
    }
}

struct CardSetResponse: Decodable {
    let data: [PokemonCardSet]
}
