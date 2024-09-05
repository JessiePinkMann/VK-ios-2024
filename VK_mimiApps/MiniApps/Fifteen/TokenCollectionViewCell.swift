//
//  TokenCollectionViewCell.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 05.09.2024.
//

import Foundation
import UIKit

class TokenCollectionViewCell: UICollectionViewCell {
    static let identifier = "TokenCollectionViewCell"
    
    private let tokenView: TokenView = {
        let view = TokenView(token: Token(id: 0, number: 0, isEmpty: true))  // Пустой токен по умолчанию
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tokenView)
        tokenView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tokenView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tokenView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tokenView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tokenView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with token: Token) {
        tokenView.removeFromSuperview()
        let newTokenView = TokenView(token: token)
        contentView.addSubview(newTokenView)
        newTokenView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newTokenView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newTokenView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newTokenView.topAnchor.constraint(equalTo: contentView.topAnchor),
            newTokenView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
