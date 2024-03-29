//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by Adem Mergen on 26.03.2024.
//

import Foundation


class PokemonListViewModel {
    var pokemons: [Pokemon] = []
    
    func fetchPokemons(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=30") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let pokemonList = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                completion(.success(pokemonList.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

class PokemonDetailViewModel {
    func fetchPokemonDetail(pokemonID: Int, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonID)")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            do {
                let pokemonDetail = try JSONDecoder().decode(PokemonDetail.self, from: data)
                completion(.success(pokemonDetail))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
