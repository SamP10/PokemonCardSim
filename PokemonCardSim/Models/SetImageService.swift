//
//  ImageLoader.swift
//  PokemonCardPackSimualator
//
//  Created by Sam Plant on 24/10/2024.
//

import SwiftUI
import UIKit

class SetImageService: ObservableObject {
    @Published var setByImage: [PokemonCardSet: UIImage] = [:]
    @Published var isLoading: Bool = true
    
    public func loadImages(cardSets: [PokemonCardSet]) async {
        if(!setByImage.isEmpty) {
            return;
        }
        
        let maxConcurrentTasks = 1
        
        await withTaskGroup(of: Void.self) { taskGroup in
            var currentBatch: [PokemonCardSet] = []
            for cardSet in cardSets {
                if(setByImage.keys.contains(cardSet)) {
                    continue;
                }
                
                currentBatch.append(cardSet)
                
                if currentBatch.count == maxConcurrentTasks {
                    await processBatch(taskGroup: &taskGroup, cardSets: currentBatch)
                    currentBatch.removeAll()
                    
                    do {
                        try await Task.sleep(nanoseconds: 100_000_000)
                    } catch {
                        print("Error during batch delay: \(error.localizedDescription)")
                    }
                }

                if !currentBatch.isEmpty {
                    await processBatch(taskGroup: &taskGroup, cardSets: currentBatch)
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.isLoading.toggle()
            }
        }
    }
    
    private func processBatch(taskGroup: inout TaskGroup<Void>, cardSets: [PokemonCardSet]) async {
         for cardSet in cardSets {
             taskGroup.addTask {
                 await self.loadImage(cardSet: cardSet)
             }
         }
     }

    private func loadImage(cardSet: PokemonCardSet) async {
        guard let url = URL(string: cardSet.images.logo ?? cardSet.images.symbol ?? "") else { return }
        
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
                self?.setByImage[cardSet] = loadedImage
            }
            
        } catch {
            print("Error fetching images: \(error.localizedDescription)")
        }
    }
}
