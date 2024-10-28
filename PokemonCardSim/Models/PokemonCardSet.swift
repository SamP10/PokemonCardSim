//
//  PokemonCardSet.swift
//  PokemonCardSim
//
//  Created by Sam Plant on 28/10/2024.
//

struct PokemonCardSet: Identifiable, Decodable {
    public var id: String
    public var name: String
    public var series: String
    
    public struct images: Decodable {
        var symbol: String?
        var logo: String?
    }
}
