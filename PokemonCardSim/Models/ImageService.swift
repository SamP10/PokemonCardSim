//
//  ImageLoader.swift
//  PokemonCardPackSimualator
//
//  Created by Sam Plant on 24/10/2024.
//

import SwiftUI
import UIKit

class ImageService: ObservableObject {
    @Published var cardByImage: [PokemonCard: UIImage] = [:]
    @Published var isLoading: Bool = true
    
    public func loadImages(cards: [PokemonCard]) async {
        let maxConcurrentTasks = 1
        
        await withTaskGroup(of: Void.self) { taskGroup in
            var currentBatch: [PokemonCard] = []
            for card in cards {
                currentBatch.append(card)
                
                if currentBatch.count == maxConcurrentTasks {
                    await processBatch(taskGroup: &taskGroup, cards: currentBatch)
                    currentBatch.removeAll()
                    
                    do {
                        try await Task.sleep(nanoseconds: 100_000_000)
                    } catch {
                        print("Error during batch delay: \(error.localizedDescription)")
                    }
                }

                if !currentBatch.isEmpty {
                    await processBatch(taskGroup: &taskGroup, cards: currentBatch)
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.isLoading.toggle()
            }
        }
    }
    
    private func processBatch(taskGroup: inout TaskGroup<Void>, cards: [PokemonCard]) async {
         for card in cards {
             taskGroup.addTask {
                 await self.loadImage(card: card)
             }
         }
     }

    private func loadImage(card: PokemonCard) async {
        guard let url = URL(string: card.images.large ?? "") else { return }
        
        let request = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error with status code: \(response)")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let loadedImage = UIImage(data: data) else { return }
                self?.cardByImage[card] = loadedImage
            }
            
        } catch {
            print("Error fetching cards: \(error.localizedDescription)")
        }
    }
}
