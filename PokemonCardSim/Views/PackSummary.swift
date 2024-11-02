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
    @State private var totalAmount: Double;
    @Binding var showFireworks: Bool;
    
    init(pack: [PokemonCard], imageService: ImageService, totalAmount: Double, showFireworks: Binding<Bool>) {
        self.pack = pack;
        self.imageService = imageService;
        self.totalAmount = totalAmount
        self._showFireworks = showFireworks
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
            
            Text(String(self.totalAmount) + "$")
                .background(
                    RoundedRectangle(cornerRadius: 9)
                        .fill(.white)
                )
                .padding()
                .onAppear {
                    self.showFireworks = true;
                }
        }
    }
}
