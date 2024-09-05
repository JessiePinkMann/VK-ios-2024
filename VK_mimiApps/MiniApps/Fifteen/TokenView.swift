//
//  TokenView.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 05.09.2024.
//

import Foundation
import UIKit

class TokenView: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.bigTitle, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = .black
        label.layer.cornerRadius = Constants.cornerRadius
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = 2
        label.clipsToBounds = true
        return label
    }()
    
    private let token: Token
    
    init(token: Token) {
        self.token = token
        super.init(frame: .zero)
        setupView()
        configureToken()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureToken() {
        if token.isEmpty {
            label.text = ""
            label.backgroundColor = .black
        } else {
            label.text = "\(token.number)"
            label.backgroundColor = .white
        }
    }
}
