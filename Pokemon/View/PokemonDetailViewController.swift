//
//  PokemonDetailViewController.swift
//  Pokemon
//
//  Created by Adem Mergen on 26.03.2024.
//


import UIKit

class PokemonDetailViewController: UIViewController {
    var pokemon: Pokemon? // Seçilen Pokemon'un bilgilerini tutacak değişken
    
    let detailViewModel = PokemonDetailViewModel()
    
    let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    lazy var abilityLabel: UILabel = makeLabel()
    lazy var weightLabel: UILabel = makeLabel()
    lazy var hpLabel: UILabel = makeLabel()
    lazy var attackLabel: UILabel = makeLabel()
    lazy var defenseLabel: UILabel = makeLabel()
    lazy var specialAttackLabel: UILabel = makeLabel()
    lazy var specialDefenseLabel: UILabel = makeLabel()
    lazy var speedLabel: UILabel = makeLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        displayPokemonDetails()
    }
    
    func setupUI() {
        view.addSubview(pokemonImageView)
        view.addSubview(nameLabel)
        view.addSubview(abilityLabel)
        view.addSubview(weightLabel)
        view.addSubview(hpLabel)
        view.addSubview(attackLabel)
        view.addSubview(defenseLabel)
        view.addSubview(specialAttackLabel)
        view.addSubview(specialDefenseLabel)
        view.addSubview(speedLabel)
        
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pokemonImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pokemonImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            abilityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 50),
            abilityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            abilityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            weightLabel.topAnchor.constraint(equalTo: abilityLabel.bottomAnchor, constant: 10),
            weightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            hpLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 10),
            hpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hpLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            attackLabel.topAnchor.constraint(equalTo: hpLabel.bottomAnchor, constant: 10),
            attackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            attackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            defenseLabel.topAnchor.constraint(equalTo: attackLabel.bottomAnchor, constant: 10),
            defenseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            defenseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            specialAttackLabel.topAnchor.constraint(equalTo: defenseLabel.bottomAnchor, constant: 10),
            specialAttackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            specialAttackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            specialDefenseLabel.topAnchor.constraint(equalTo: specialAttackLabel.bottomAnchor, constant: 10),
            specialDefenseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            specialDefenseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            speedLabel.topAnchor.constraint(equalTo: specialDefenseLabel.bottomAnchor, constant: 10),
            speedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            speedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func displayPokemonDetails() {
        if let pokemon = pokemon {
            nameLabel.text = pokemon.name
            
            // Pokemon detaylarını almak için API'ye istek gönder
            detailViewModel.fetchPokemonDetail(pokemonID: extractPokemonID(from: pokemon.url)) { result in
                switch result {
                case .success(let pokemonDetail):
                    if let imageURLString = pokemonDetail.sprites.front_default,
                       let imageURL = URL(string: imageURLString),
                       let imageData = try? Data(contentsOf: imageURL),
                       let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.pokemonImageView.image = image
                            self.pokemonImageView.contentMode = .scaleAspectFit
                        }
                    }
                    
                    // Yetenekleri göster
                    let abilitiesText = pokemonDetail.abilities.map { $0.ability.name }.joined(separator: ", ")
                    DispatchQueue.main.async {
                        self.abilityLabel.text = "Abilities: \(abilitiesText)"
                    }
                    
                    // Ağırlığı göster
                    DispatchQueue.main.async {
                        self.weightLabel.text = "Weight: \(pokemonDetail.weight)"
                    }
                    
                    // HP değerini göster
                    DispatchQueue.main.async {
                        if let hpStat = pokemonDetail.stats.first(where: { $0.stat.name == "hp" }) {
                            self.hpLabel.text = "Hp: \(hpStat.base_stat)"
                        } else {
                            self.hpLabel.text = "Hp: N/A"
                        }
                    }
                    
                    // Attack değerini göster
                    DispatchQueue.main.async {
                        if let attackStat = pokemonDetail.stats.first(where: { $0.stat.name == "attack" }) {
                            self.attackLabel.text = "Attack: \(attackStat.base_stat)"
                        } else {
                            self.attackLabel.text = "Attack: N/A"
                        }
                    }
                    
                    // Defense değerini göster
                    DispatchQueue.main.async {
                        if let defenseStat = pokemonDetail.stats.first(where: { $0.stat.name == "defense" }) {
                            self.defenseLabel.text = "Defense: \(defenseStat.base_stat)"
                        } else {
                            self.defenseLabel.text = "Defense: N/A"
                        }
                    }
                    
                    // Special attack değerini göster
                    DispatchQueue.main.async {
                        if let specialAttackStat = pokemonDetail.stats.first(where: { $0.stat.name == "special-attack" }) {
                            self.specialAttackLabel.text = "Special Attack: \(specialAttackStat.base_stat)"
                        } else {
                            self.specialAttackLabel.text = "Special Attack: N/A"
                        }
                    }
                    
                    // Special defense değerini göster
                    DispatchQueue.main.async {
                        if let specialDefenseStat = pokemonDetail.stats.first(where: { $0.stat.name == "special-defense" }) {
                            self.specialDefenseLabel.text = "Special Defense: \(specialDefenseStat.base_stat)"
                        } else {
                            self.specialDefenseLabel.text = "Special Defense: N/A"
                        }
                    }
                    
                    // Speed değerini göster
                    DispatchQueue.main.async {
                        if let speedStat = pokemonDetail.stats.first(where: { $0.stat.name == "speed" }) {
                            self.speedLabel.text = "Speed: \(speedStat.base_stat)"
                        } else {
                            self.speedLabel.text = "Speed: N/A"
                        }
                    }
                    
                case .failure(let error):
                    print("Error fetching Pokemon detail: \(error)")
                    
                }
            }
        }
    }
    
    func extractPokemonID(from url: String) -> Int {
        if let idString = url.split(separator: "/").last, let id = Int(idString) {
            return id
        } else {
            return 0
        }
    }
}

