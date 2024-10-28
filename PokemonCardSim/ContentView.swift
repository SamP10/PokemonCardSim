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

    var body: some View {
        VStack{
            if(self.cardSetService.isLoading) {
                ProgressView()
                    .frame(width: 50, height: 50)
            } else {
                NavigationStack {
                    List {
                        ForEach(self.cardSetService.sets) { set in
                            NavigationLink() {
                                CardSetView(setId: set.id)
                                    .navigationTitle(Text(set.name))
                            } label: {
                                Text(set.name)
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            Task {
                await self.cardSetService.fetchCardSets()
            }
        }
    }
}

#Preview{
    PokemonCardSetView()
}

