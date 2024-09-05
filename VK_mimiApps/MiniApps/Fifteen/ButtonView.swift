//
//  ButtonView.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 05.09.2024.
//

import Foundation
import UIKit

class ButtonView: UIView {
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restart", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.smallTitle, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.right.2"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let buttonClicked: () -> Void
    
    init(buttonClicked: @escaping () -> Void) {
        self.buttonClicked = buttonClicked
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func buttonTapped() {
        buttonClicked()
    }
}
