//
//  RarityTypes.swift
//  PokemonCardPackSimualator
//
//  Created by Sam Plant on 24/10/2024.
//

public enum cardRarity: String, CaseIterable, Identifiable {
    case amazingRare
    case common
    case LEGEND
    case promo
    case rare
    case rareACE
    case rareBREAK
    case rareHolo
    case rareHoloEX
    case rareHoloGX
    case rareHoloLVX
    case rareHoloStar
    case rareHoloV
    case rareHoloVMAX
    case rarePrime
    case rarePrismStar
    case rareRainbow
    case rareSecret
    case rareShining
    case rareShiny
    case rareShinyGX
    case rareUltra
    case uncommon
    
    public var id: String { self.rawValue }
};
