//
//  PokemonListResponse.swift
//  Pokemon
//
//  Created by Adem Mergen on 26.03.2024.
//

import Foundation

struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonDetail: Codable {

    let sprites: Sprites
    let abilities: [Ability]
    let weight: Int
    let stats: [Stat]
    
}

struct Sprites: Codable {
    let front_default: String?
}

struct Ability: Codable {
    let ability: AbilityInfo
}

struct AbilityInfo: Codable {
    let name: String
}

struct Stat: Codable {
    let base_stat: Int
    let stat: StatInfo
}

struct StatInfo: Codable {
    let name: String
}










