//
//  PokemonTableViewCell.swift
//  Pokemon
//
//  Created by Adem Mergen on 26.03.2024.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    static let reuseIdentifier = "PokemonCell"
    
    let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(pokemonImageView)
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            pokemonImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            pokemonImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            pokemonImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 100),
            
            nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 0),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}




