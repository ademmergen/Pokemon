//
//  ViewController.swift
//  Pokemon
//
//  Created by Adem Mergen on 26.03.2024.
//

import UIKit

class PokemonListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    let listViewModel = PokemonListViewModel()
    let detailViewModel = PokemonDetailViewModel()
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPokemons()
    }
    
    func fetchPokemons() {
        listViewModel.fetchPokemons { result in
            switch result {
            case .success(let pokemons):
                self.pokemons = pokemons
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Pokemon listesi alınamadı. Hata: \(error)")
            }
        }
    }
    
    func setupUI() {
        
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
    }
    
    // MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            if let selectedIndex = sender as? Int,
               let destinationVC = segue.destination as? PokemonDetailViewController {
                let selectedPokemon = pokemons[selectedIndex]
                destinationVC.pokemon = selectedPokemon
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.reuseIdentifier, for: indexPath) as! PokemonTableViewCell
        let pokemon = pokemons[indexPath.row]
        cell.nameLabel.text = pokemon.name
        
        detailViewModel.fetchPokemonDetail(pokemonID: indexPath.row + 1) { result in
            switch result {
            case .success(let pokemonDetail):
                if let imageURLString = pokemonDetail.sprites.front_default,
                   let imageURL = URL(string: imageURLString) {
                    URLSession.shared.dataTask(with: imageURL) { data, response, error in
                        guard let data = data, let image = UIImage(data: data) else { return }
                        DispatchQueue.main.async {
                            cell.pokemonImageView.image = image
                        }
                    }.resume()
                }
            case .failure(let error):
                print("Error fetching Pokemon detail: \(error)")
            }
        }
        
        return cell
    }
}








