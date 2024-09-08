//
//  TicTacToeCell.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 06.09.2024.
//

import UIKit

class TicTacToeCell: UICollectionViewCell {
    static let identifier = "TicTacToeCell"
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(symbolLabel)
        contentView.backgroundColor = UIColor(named: "primaryBackground")
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.black.cgColor
        
        NSLayoutConstraint.activate([
            symbolLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            symbolLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with symbol: String) {
        symbolLabel.text = symbol
        symbolLabel.textColor = UIColor.label
    }
}
