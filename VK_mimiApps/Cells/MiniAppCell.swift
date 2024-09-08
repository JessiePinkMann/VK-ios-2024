//
//  MiniAppCell.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 05.09.2024.
//

import UIKit

class MiniAppCell: UITableViewCell {

    static let identifier = "MiniAppCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let appImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let descriptionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let descriptionBubble: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(named: "primaryBubble")
        label.textColor = UIColor(named: "descriptionText")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var isBubbleVisible = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .default
        
        contentView.addSubview(appImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoButton)
        
        contentView.addSubview(descriptionContainer)
        descriptionContainer.addSubview(descriptionBubble)

        setupConstraints()
        
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(named: "primaryBackground")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String, imageName: String, description: String, isInteractive: Bool) {
        titleLabel.text = title
        appImageView.image = UIImage(named: imageName)
        descriptionBubble.text = description
        
        if isInteractive {
            selectionStyle = .default
            contentView.isUserInteractionEnabled = true
        } else {
            selectionStyle = .none
            contentView.isUserInteractionEnabled = false
        }
    }
    

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            appImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            appImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            appImageView.widthAnchor.constraint(equalToConstant: 50),
            appImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: appImageView.trailingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            infoButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            descriptionContainer.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -10),
            descriptionContainer.bottomAnchor.constraint(equalTo: infoButton.topAnchor, constant: -5),
            descriptionContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            descriptionBubble.leadingAnchor.constraint(equalTo: descriptionContainer.leadingAnchor),
            descriptionBubble.trailingAnchor.constraint(equalTo: descriptionContainer.trailingAnchor),
            descriptionBubble.topAnchor.constraint(equalTo: descriptionContainer.topAnchor),
            descriptionBubble.bottomAnchor.constraint(equalTo: descriptionContainer.bottomAnchor)
        ])
    }

    @objc private func infoButtonTapped(_ sender: UIButton) {
        isBubbleVisible.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.descriptionBubble.alpha = self.isBubbleVisible ? 1 : 0
        }
        
        if isBubbleVisible {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.hideDescriptionBubble()
            }
        }
    }

    private func hideDescriptionBubble() {
        if isBubbleVisible {
            UIView.animate(withDuration: 0.3) {
                self.descriptionBubble.alpha = 0
            }
            isBubbleVisible = false
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let infoButtonPoint = infoButton.convert(point, from: self)
        if infoButton.bounds.contains(infoButtonPoint) {
            return infoButton
        }
        return super.hitTest(point, with: event)
    }
}
