//
//  PackSummary.swift
//  PokemonCardSim
//
//  Created by Sam Plant on 31/10/2024.
//

import SwiftUI
import CoreData
import UIKit

struct PackSummary: View {
    @State private var imageService: ImageService;
    private var pack: [PokemonCard];
    
    init(pack: [PokemonCard], imageService: ImageService) {
        self.pack = pack;
        self.imageService = imageService;
    }

    var body: some View {
        ScrollView {
                ForEach(self.pack.reversed(), id: \.id) { card in
                    VStack {
                        CardImageView(uiImage: self.imageService.cardByImage[card] ?? UIImage()){
                            return 0
                        }.frame(alignment: .center)
                        Text(String(card.rarity ?? "Unknown"))
                            .foregroundStyle(.black)
                        Text(String(card.cardmarket.prices.averageSellPrice)+"$")
                            .foregroundStyle(.black)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 9)
                            .fill(.white)
                    )
                    .padding()
                }
        }
    }
}
