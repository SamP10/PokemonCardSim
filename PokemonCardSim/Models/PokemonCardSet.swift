//
//  PokemonCardSet.swift
//  PokemonCardSim
//
//  Created by Sam Plant on 28/10/2024.
//
import Foundation

struct PokemonCardSet: Identifiable, Decodable, Equatable, Hashable {
    public var id: String
    public var name: String
    public var series: String
    public var images: Images
    
    public struct Images: Decodable, Equatable, Hashable {
        var symbol: String?
        var logo: String?
    }
}
