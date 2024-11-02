//
//  ContentView.swift
//  PokemonCardPackSimualator
//
//  Created by Sam Plant on 24/10/2024.
//

import SwiftUI
import CoreData
import UIKit

struct PokemonCardSetView: View {
    @StateObject var cardSetService: CardSetService = CardSetService()
    @StateObject var setImageService: SetImageService = SetImageService()

    var body: some View {
        VStack{
            if(self.cardSetService.isLoading || self.setImageService.isLoading) {
                RotatingImageView(imageName: "Pokeball", size: 50)
            } else {
                NavigationStack {
                    List {
                        ForEach(self.cardSetService.sets) { set in
                            NavigationLink() {
                                CardSetView(setId: set.id)
                                    .navigationTitle(Text(set.name))
                                
                            } label: {
                                HStack {
                                    Image(uiImage: self.setImageService.setByImage[set] ?? UIImage())
                                        .resizable()
                                        .frame(maxWidth: 80, maxHeight: 40)
                                    Text(set.name)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            Task {
                await self.cardSetService.fetchCardSets()
                await self.setImageService.loadImages(cardSets: self.cardSetService.sets)
            }
        }
    }
}
