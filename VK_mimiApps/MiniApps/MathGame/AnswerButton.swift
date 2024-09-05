//
//  AnswerButton.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 05.09.2024.
//

import Foundation
import UIKit

class AnswerButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = 40
        self.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 80),
            self.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}
